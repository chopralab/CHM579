! file: mc-007.f90
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
  real :: hbox
  real :: rcut                 ! cut-off distance for interactions
  real :: eps,sig
  
  real :: ddx,ddy,ddz,dd
  real :: u

  print*
  print*,' A Monte Carlo program for Lennard-Jones particles'
  print*

  eps=0.650d0
  sig=0.3166d0

  rcut=0.7d0            ! Assign value to cut-off distance

  print*,' Lennard-Jones parameters:'
  print*,'   eps= ',eps,' kJ/mol'
  print*,'   sig= ',sig,' nm'
  print*,'  rcut= ',rcut,' nm'
  print*

  box=1.5d0
  hbox=box/2.0
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

  u=0.0e0                       ! Zero variable 

  do i=1,np-1
     do j=i+1,np
        
        ddx=x(i)-x(j)
        ddy=y(i)-y(j)
        ddz=z(i)-z(j)

        if (ddx > hbox) ddx=ddx-box  ! Take the shortest distance
        if (ddy > hbox) ddy=ddy-box
        if (ddz > hbox) ddz=ddz-box

        if (ddx < -hbox) ddx=ddx+box
        if (ddy < -hbox) ddy=ddy+box
        if (ddz < -hbox) ddz=ddz+box

        dd=sqrt(ddx*ddx+ddy*ddy+ddz*ddz)  ! distance between "i" and "j"
        
        if (dd <= rcut) then              ! Spherical cut-off
           u = u + ( (sig/dd)**12 - (sig/dd)**6 )  
        endif

     enddo
  enddo

  u=u*4.0*eps

!-- end calculation of potential energy-------------------

  print*
  print*,' Initial Potential Energy: ',u 
  print*

  stop
end program lennard
