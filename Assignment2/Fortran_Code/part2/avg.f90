program average
  implicit none
  
  character(1000000) :: arg1
  integer :: dummy, i, n
  double precision :: avg,aux

  ! print*,'Number of lines to average:'
  ! read*,n

  call get_command_argument(1, arg1)
  READ(arg1,*)n


  avg=0.0d0

  open(unit=9,file="pressure.dat")
  do i=1,n
     read(9,*)dummy,aux
     avg=aux+avg
  enddo
  close(9)

  print*,'<P>=',avg/(n*1.d0)
      
  avg=0.0d0

  open(unit=9,file="energy.dat")
  do i=1,n
     read(9,*)dummy,aux
     avg=aux+avg
  enddo
  close(9)

  print*,'<E>=',avg/(n*1.d0)
      
end program average
