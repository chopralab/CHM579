! file: mc-014.f90
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
  real :: rcut
  real :: eps,sig
  real :: u 
  integer :: step
  real :: temp                
  real, parameter :: kboltzman=8.316e-3

  integer :: ar,acc    ! counters

  print*
  print*,' A Monte Carlo program for Lennard-Jones particles'
  print*

  eps=0.650d0
  sig=0.3166d0
  
  rcut=0.7d0

  print*,' Lennard-Jones parameters:'
  print*,'   eps= ',eps,' kJ/mol'
  print*,'   sig= ',sig,' nm'
  print*,'  rcut= ',rcut,' nm'
  print*
  
  box=1.5d0
  hbox=box/2.0
  vol=box**3
  ndens=np/vol
  temp=300.d0
  
  print*,' Simulation box length: ',box
  print*,' Volume               : ',vol
  print*,' Number density       : ',ndens
  print*,' Temperature          : ',temp
  print*
  
  print*,' Initial coordinates'

  do i=1,np
     x(i)=ran()*box
     y(i)=ran()*box
     z(i)=ran()*box
     print*,i,x(i),y(i),z(i)
  enddo
  
  call energy(u,np,x,y,z,eps,sig,box,hbox,rcut,0)

  print*
  print*,' Initial Potential Energy: ',u 
  print*
  
  acc=0
  do step=1,10        ! we call a subroutine to move the particles
     
     call move(u,np,x,y,z,eps,sig,box,hbox,rcut,temp,ar)
     acc=acc+ar        ! ar=1 if move was accepted, 0 if not.
     
  enddo
  
  print*,' Final energy (updated): ',u
  print*
  
  call energy(u,np,x,y,z,eps,sig,box,hbox,rcut,0)
  print*,' Final energy (recalculated): ',u
  print*
  
  print*,' Number of accepted moves: ',acc
  print*
  
  stop
end program lennard

!------------------------------------------------------------------
!------------------------------------------------------------------

subroutine move(u,np,x,y,z,eps,sig,box,hbox,rcut,temp,ar)
  
  implicit none
  integer :: np,ar,i,j,it
  real :: u,eps,sig,box,hbox,rcut,temp
  real :: x(np),y(np),z(np)
  real :: xold,yold,zold
  real :: ddx,ddy,ddz,dd
  real :: u0,u1,deltau
  real, parameter :: kboltzman=8.316e-3
  
  it=int(ran()*np)+1
  
  call energy(u0,np,x,y,z,eps,sig,box,hbox,rcut,it)
  
  xold=x(it)
  yold=y(it)
  zold=z(it)
  
  x(it)=x(it) + (ran()-0.5)
  y(it)=y(it) + (ran()-0.5)
  z(it)=z(it) + (ran()-0.5)
  
  if (x(it) > box) x(it)=x(it)-box
  if (y(it) > box) y(it)=y(it)-box
  if (z(it) > box) z(it)=z(it)-box
  if (x(it) < 0.d0) x(it)=x(it)+box
  if (y(it) < 0.d0) y(it)=y(it)+box
  if (z(it) < 0.d0) z(it)=z(it)+box
  
  call energy(u1,np,x,y,z,eps,sig,box,hbox,rcut,it)
  
  deltau=u1-u0
  
  if (deltau < 0.) then
     u=u+deltau
     ar=1
  elseif (exp(-deltau/(kboltzman*temp)) >= ran()) then
     u=u+deltau
     ar=1
  else
     x(it)=xold
     y(it)=yold
     z(it)=zold
     ar=0
  endif
  
  return
end subroutine move

!------------------------------------------------------------------
!------------------------------------------------------------------

subroutine energy(u,np,x,y,z,eps,sig,box,hbox,rcut,it)
  
  implicit none
  integer :: np,it
  real :: u,eps,sig,box,hbox,rcut
  real :: x(np),y(np),z(np)

  integer :: i,j
  real :: ddx,ddy,ddz,dd

  if (it == 0) then

     u=0.0e0
     
     do i=1,np-1
        do j=i+1,np
           
           ddx=x(i)-x(j)
           ddy=y(i)-y(j)
           ddz=z(i)-z(j)
           
           if (ddx > hbox) ddx=ddx-box
           if (ddy > hbox) ddy=ddy-box
           if (ddz > hbox) ddz=ddz-box
           
           if (ddx < -hbox) ddx=ddx+box
           if (ddy < -hbox) ddy=ddy+box
           if (ddz < -hbox) ddz=ddz+box
           
           dd=sqrt(ddx*ddx+ddy*ddy+ddz*ddz)
           
           if (dd <= rcut) then
              u = u + ( (sig/dd)**12 - (sig/dd)**6 )  
           endif
           
        enddo
     enddo
     
     u=u*4.0*eps
     
  else
     
     u=0.0e0
     
     do i=1,np
        if (i .ne. it) then
           
           ddx=x(i)-x(it)
           ddy=y(i)-y(it)
           ddz=z(i)-z(it)
           
           if (ddx > hbox) ddx=ddx-box
           if (ddy > hbox) ddy=ddy-box
           if (ddz > hbox) ddz=ddz-box
           
           if (ddx < -hbox) ddx=ddx+box
           if (ddy < -hbox) ddy=ddy+box
           if (ddz < -hbox) ddz=ddz+box
           
           dd=sqrt(ddx*ddx+ddy*ddy+ddz*ddz)
           
           if (dd <= rcut) then
              u = u + ( (sig/dd)**12 - (sig/dd)**6 )  
           endif
           
        endif
     enddo
     
     u=u*4.0*eps
     
  endif
  
  return
end subroutine energy
