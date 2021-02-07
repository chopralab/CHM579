!   file: mc-002.f90
!
! Lennard-Jones particles
!
! Marcelo A. Carignano
! Chemistry - Purdue U.
! February 2008
!

program lennard
  implicit none

  integer :: i                                ! We define variables  
  integer, parameter :: np=20                 ! Number of particles

  real :: x(np),y(np),z(np)             ! Coord. x,y,z for particles
                                        ! x,y,z are ARRAYS

  real :: box,vol,ndens

  print*
  print*,' A Monte Carlo program for Lennard-Jones particles'
  print*

  print*,' Initial coordinates'

  do i=1,np
     print*,i,x(i),y(i),z(i)
  enddo
  print*
  
  stop
end program lennard
