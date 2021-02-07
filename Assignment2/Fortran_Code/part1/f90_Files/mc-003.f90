!   file: mc-003.f90
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

  real :: x(np)=0,y(np)=0,z(np)=0       ! Coord. x,y,z for particles
                                        ! x,y,z are ARRAYS
                                        ! Note how we initialize the array

  real :: box,vol,ndens

  real :: eps,sig                       ! Lennard-Jones parameters
  
  print*
  print*,' A Monte Carlo program for Lennard-Jones particles'
  print*
  
  eps=0.650d0    ! eps has units of energy
  sig=0.3166d0   ! sig has units of length
  
  print*,' Lennard-Jones parameters:'
  print*,'   eps= ',eps,' kJ/mol'
  print*,'   sig= ',sig,' nm'
  print*
  
  box=1.5d0        ! Assign value to the simulation box length
  vol=box**3       ! and calculating the box's volume
  ndens=np/vol     ! Number density (there is no mass in MC)
  
  print*,' Simulation box length: ',box
  print*,' Volume               : ',vol
  print*,' Number density       : ',ndens
  print*
  
  print*,' Initial coordinates'
  
  do i=1,np
     print*,i,x(i),y(i),z(i)
  enddo
  print*

  stop
end program lennard
