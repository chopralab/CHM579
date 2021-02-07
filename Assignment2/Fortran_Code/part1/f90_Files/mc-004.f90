! file: mc-004.f90
!
! Lennard-Jones particles
!
! Marcelo A. Carignano
! Chemistry - Purdue U.
! February 2008
!

program lennard
  implicit none

  integer :: i
  integer, parameter :: np=20

  real :: x(np)=0,y(np)=0,z(np)=0

  real :: box,vol,ndens

  real :: eps,sig

  print*
  print*,' A Monte Carlo program for Lennard-Jones particles'
  print*

  eps=0.650d0
  sig=0.3166d0

  print*,' Lennard-Jones parameters:'
  print*,'   eps= ',eps,' kJ/mol'
  print*,'   sig= ',sig,' nm'
  print*

  box=1.5d0
  vol=box**3
  ndens=np/vol

  print*,' Simulation box length: ',box
  print*,' Volume               : ',vol
  print*,' Number density       : ',ndens
  print*

  print*,' Initial coordinates'

  do i=1,np
     x(i)=ran()*box           ! Assign random initial coord.
     y(i)=ran()*box           ! 0 < ran() < 1
     z(i)=ran()*box           ! then 0 < x,y,z < box
     print*,i,x(i),y(i),z(i)
  enddo
  print*

  stop
end program lennard
