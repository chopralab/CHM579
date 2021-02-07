! file: mc-005.f90
!
! Lennard-Jones particles
!  (truncated)
!
! Marcelo A. Carignano
! Chemistry - Purdue U.
! February 2008
!

program lennard
  implicit none

  integer :: i,j
  integer, parameter :: np=20
  real :: x(np)=0,y(np)=0,z(np)=0
  real :: box,vol,ndens
  real :: eps,sig
  
  real :: ddx,ddy,ddz,dd       ! To compute distances
  real :: u                    ! System's potential energy

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
     x(i)=ran()*box
     y(i)=ran()*box
     z(i)=ran()*box
     print*,i,x(i),y(i),z(i)
  enddo

!-- start calculation of potential energy-----------------

  u=0.0d0                       ! Zero variable 
  
  do i=1,np-1
     do j=i+1,np

        ddx=x(i)-x(j)
        ddy=y(i)-y(j)
        ddz=z(i)-z(j)

        dd=sqrt(ddx*ddx+ddy*ddy+ddz*ddz)  ! distance between "i" and "j"
        
        u = u + ( (sig/dd)**12 - (sig/dd)**6 )  

     enddo
  enddo

  u=u*4.0*eps
  
!-- end calculation of potential energy-------------------

  print*
  print*,' Initial Potential Energy: ',u 
  print*
  
  stop
end program lennard
