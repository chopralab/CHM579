! file: mc-016.f90
! Lennard-Jones particles(truncated) 
! Marcelo A. Carignano - Dept. of Chemistry - Purdue University
! January 2009

program lennard
  implicit none

  integer :: i,j
  integer :: np
  double precision, allocatable :: x(:),y(:),z(:)
  double precision :: box,vol,ndens,dens
  double precision :: hbox
  double precision :: rcut
  double precision :: eps,sig
  double precision :: u,vir,ecorrection,vircorrection,pres
  integer :: step,mcsteps,mceq,mcf
  double precision :: temp                
  double precision, parameter :: kboltzman=1.d0

  integer :: ar,acc,att
  double precision :: maxd
  integer :: istart
  double precision :: pi
  integer :: nsample,nadjust

  pi=dacos(-1.0d0)

  print*
  print*,' A Monte Carlo program for Lennard-Jones particles'
  print*,' -------------------------------------------------'
  
  open(unit=1,file='input')
!  read(1,*)eps,sig          ! potential parameters
  eps=1.0d0
  sig=1.0d0
  read(1,*)rcut

  read(1,*)np               ! system's size

  allocate (x(np),y(np),z(np))

  print*,' Lennard-Jones parameters:'
  print*,'   eps= ',eps
  print*,'   sig= ',sig
  print*,'  rcut= ',rcut
  print*

  read(1,*)dens             ! thermodynamical conditions
  read(1,*)temp

  ndens=dens/sig**3
  vol=np/ndens
  box=vol**(1.0/3.0)
  hbox=box/2.0

  print*,' Simulation box length: ',box
  print*,' Volume               : ',vol
  print*,' Number density       : ',dens
  print*,' Density              : ',ndens
  print*,' Temperature          : ',temp
  print*

  read(1,*)istart
  read(1,*)maxd

  if (istart == 0) then
     print*,'istart = 0 -> Random initial configuration'
     do i=1,np
        x(i)=ran()*box
        y(i)=ran()*box
        z(i)=ran()*box
     enddo
  elseif (istart == 1) then
     print*,'istart = 1 -> Read initial configuration'
     open(unit=2,file='conf.gro')
     do i=1,np
        read(2,*)j,x(i),y(i),z(i)
     enddo
     close(unit=2)
  endif
  
  read(1,*)mceq,mcsteps
  read(1,*)nsample
  read(1,*)nadjust

  print*
  print*,' maxd           : ',maxd
  print*,' # eq steps     : ',mceq
  print*,' # MC steps     : ',mcsteps
  print*,' Sampling freq  : ',nsample
  print*,' Adjusting freq : ',nadjust
  print*

  call energy(u,np,x,y,z,eps,sig,box,hbox,rcut,0)
  
  print*
  print*,' Initial Potential Energy: ',u
  print*
  
  open(unit=20,file='energy.dat')
  open(unit=21,file='pressure.dat')
  
  acc=0
  att=0

  do mcf=1,2
  
     if (mcf == 1) then
        do step=1,mceq
           call move(u,np,x,y,z,eps,sig,box,hbox,rcut,maxd,temp,ar)
           acc=acc+ar
           att=att+1
           if (mod(step,nadjust) == 0) call adjust(att,acc,maxd,box)
        enddo
     elseif (mcf == 2) then
        do step=1,mcsteps
           call move(u,np,x,y,z,eps,sig,box,hbox,rcut,maxd,temp,ar)
           acc=acc+ar
           att=att+1
           if (mod(step,nsample) == 0) then
              write(20,*)step,u
              call virial(vir,np,x,y,z,eps,sig,box,hbox,rcut)

              pres=kboltzman*temp*ndens + vir/vol

              write(21,*)step,pres
           endif
           if (mod(step,nadjust) == 0) call adjust(att,acc,maxd,box)
        enddo
     endif

  enddo

  close(unit=20)
  close(unit=21)
  
  print*,' Final energy (updated):      ',u
  
  call energy(u,np,x,y,z,eps,sig,box,hbox,rcut,0)
  print*,' Final energy (recalculated): ',u
  print*

  ecorrection=np*eps*8./3.*pi*dens*((1./3.)*(sig/rcut)**9-(sig/rcut)**3)
  print*,' Energy correction: ',ecorrection
  
  vircorrection=-(16./3.)*pi*eps*(dens**2)*(1.0/rcut)**3
  print*,' Pressure correction: ',vircorrection
  print*

  open(unit=21,file='output')   ! everything is going to be written in 
                                ! the output file
!  write(21,*)eps,sig
  write(21,*)rcut
  write(21,*)np
  write(21,*)dens
  write(21,*)temp
  write(21,*)istart
  write(21,*)maxd
  write(21,*)mceq,mcsteps
  write(21,*)nsample
  write(21,*)nadjust
  close(unit=21)

  open(unit=21,file='confout.gro')
  do i=1,np
     write(21,*)i,x(i),y(i),z(i)
  enddo
  close(unit=21)

  stop
end program lennard

!------------------------------------------------------------------
!------------------------------------------------------------------

subroutine move(u,np,x,y,z,eps,sig,box,hbox,rcut,maxd,temp,ar)
  
  implicit none
  integer :: np,ar,i,j,it
  double precision :: u,eps,sig,box,hbox,rcut,maxd,temp
  double precision :: x(np),y(np),z(np)
  double precision :: xold,yold,zold
  double precision :: ddx,ddy,ddz,dd
  double precision :: u0,u1,deltau
  double precision, parameter :: kboltzman=1.0d0
  
  it=int(ran()*np)+1
  
  call energy(u0,np,x,y,z,eps,sig,box,hbox,rcut,it)
  
  xold=x(it)
  yold=y(it)
  zold=z(it)
  
  x(it)=x(it) + (ran()-0.5)*maxd
  y(it)=y(it) + (ran()-0.5)*maxd
  z(it)=z(it) + (ran()-0.5)*maxd
  
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
  double precision :: u,eps,sig,box,hbox,rcut
  double precision :: x(np),y(np),z(np)

  integer :: i,j
  double precision :: ddx,ddy,ddz,dd

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

!------------------------------------------------------------------
!------------------------------------------------------------------

subroutine adjust(att,acc,maxd,box)
  
  implicit none
  integer :: att,acc
  double precision :: maxd,box,ratio

  if (att .ne. 0) then
     ratio=(acc*1.d0)/(att*1.0d0)
     if (ratio > 0.50) then
        maxd=maxd*1.05
     else
        maxd=maxd*0.95
     endif
  endif

  if ( maxd > box/4.) maxd=box/4.0    ! never too large

  acc=0
  att=0

  return
end subroutine adjust

!------------------------------------------------------------------
!------------------------------------------------------------------

subroutine virial(vv,np,x,y,z,eps,sig,box,hbox,rcut)

  implicit none
  integer :: np
  double precision :: vv,eps,sig,box,hbox,rcut
  double precision :: x(np),y(np),z(np)

  integer :: i,j
  double precision :: ddx,ddy,ddz,dd

  vv=0.0d0

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
           vv = vv + ( 2.0* (sig/dd)**12 - (sig/dd)**6 )  
        endif
            
     enddo
  enddo

  vv=vv*(24.0d0/3.0d0)*eps

  return
end subroutine virial
