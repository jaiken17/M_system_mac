module M_system
use,intrinsic     :: iso_c_binding,   only : c_float, c_int, c_char
use,intrinsic     :: iso_c_binding,   only : c_ptr, c_f_pointer, c_null_char, c_null_ptr
use,intrinsic     :: iso_c_binding
use,intrinsic     :: iso_fortran_env, only : int8, int16, int32, int64 ! , real32, real64, real128, dp=>real128

implicit none
private
integer,parameter,public :: mode_t=int32

public :: system_rand
public :: system_srand


public :: system_getpid                  ! return process ID
public :: system_getppid                 ! return parent process ID
public :: system_getuid, system_geteuid  ! return user ID
public :: system_getgid, system_getegid  ! return group ID
public :: system_setsid
public :: system_getsid
public :: system_kill                    ! (pid, signal) kill process (defaults: pid=0, signal=SIGTERM)
public :: system_signal                  ! (signal,[handler]) install signal handler subroutine

public :: system_errno
public :: system_perror

public :: system_putenv
public :: system_getenv
public :: set_environment_variable
public :: system_unsetenv

public :: system_initenv
public :: system_readenv
public :: system_clearenv

public :: system_stat                    ! call stat(3c) to determine system information of file by name
public :: system_perm                    ! create string representing file permission and type
public :: system_access                  ! determine filename access or existence
public :: system_isdir                   ! determine if filename is a directory
public :: system_islnk                   ! determine if filename is a link
public :: system_isreg                   ! determine if filename is a regular file
public :: system_isblk                   ! determine if filename is a block device
public :: system_ischr                   ! determine if filename is a character device
public :: system_isfifo                  ! determine if filename is a fifo - named pipe
public :: system_issock                  ! determine if filename is a socket
public :: system_realpath                ! resolve pathname

public :: system_chdir
public :: system_rmdir
public :: system_remove
public :: system_rename

public :: system_mkdir
public :: system_mkfifo
public :: system_chmod
public :: system_chown
public :: system_link
public :: system_unlink
public :: system_utime

public :: system_setumask
public :: system_getumask
private :: system_umask

public :: system_getcwd

public :: system_opendir
public :: system_readdir
public :: system_rewinddir
public :: system_closedir

public :: system_cpu_time

public :: system_uname
public :: system_gethostname
public :: system_getlogin
public :: system_getpwuid
public :: system_getgrgid
public :: fileglob

public :: system_alarm
public :: system_calloc
public :: system_clock
public :: system_time

public :: system_realloc
public :: system_malloc
public :: system_free
public :: system_memcpy

public :: system_dir

public :: R_GRP,R_OTH,R_USR,RWX_G,RWX_O,RWX_U,W_GRP,W_OTH,W_USR,X_GRP,X_OTH,X_USR,DEFFILEMODE,ACCESSPERMS
public :: R_OK,W_OK,X_OK,F_OK  ! for system_access

type, bind(C) :: dirent_SYSTEMA
  integer(c_long)    :: d_ino
  integer(c_long)    :: d_off; ! __off_t, check size
  integer(c_short)   :: d_reclen
  character(len=1,kind=c_char) :: d_name(256)
end type

type, bind(C) :: dirent_CYGWIN
  integer(c_int)       :: d_version
  integer(c_long)      :: d_ino
  character(kind=c_char)    :: d_type
  character(kind=c_char)    :: d_unused1(3)
  integer(c_int)       :: d_internal1
  character(len=1,kind=c_char) ::  d_name(256)
end type

  interface
    function system_alarm(seconds) bind(c, name="alarm")
      import c_int
      integer(kind=c_int), value :: seconds
      integer(kind=c_int) system_alarm
    end function system_alarm
  end interface
  interface
    function system_calloc(nelem, elsize) bind(c, name="calloc")
      import C_SIZE_T, C_INTPTR_T
      integer(C_SIZE_T), value :: nelem, elsize
      integer(C_INTPTR_T) system_calloc
    end function system_calloc
  end interface
  interface
    pure function system_clock() bind(c, name="clock")
      import C_LONG
      integer(C_LONG) system_clock
    end function system_clock
  end interface
interface
  subroutine  system_memcpy(dest, src, n) bind(C,name='memcpy')
     import C_INTPTR_T, C_SIZE_T
     INTEGER(C_INTPTR_T), value  :: dest
     INTEGER(C_INTPTR_T), value  :: src
     integer(C_SIZE_T), value    :: n
  end subroutine system_memcpy
end interface
  interface
    subroutine system_free(ptr) bind(c, name="free")
      import C_INTPTR_T
      integer(C_INTPTR_T), value :: ptr
    end subroutine system_free
  end interface
  interface
    function system_malloc(size) bind(c, name="malloc")
      import C_SIZE_T, C_INTPTR_T
      integer(C_SIZE_T), value :: size
      integer(C_INTPTR_T) system_malloc
    end function system_malloc
  end interface
  interface
    function system_realloc(ptr, size) bind(c, name="realloc")
      import C_SIZE_T, C_INTPTR_T
      integer(C_INTPTR_T), value :: ptr
      integer(C_SIZE_T), value :: size
      integer(C_INTPTR_T) system_realloc
    end function system_realloc
  end interface
  interface
    function system_time(tloc) bind(c, name="time")
      ! tloc argument should be loaded via C_LOC from iso_c_binding
      import C_PTR, C_LONG
      type(C_PTR), value :: tloc
      integer(C_LONG) system_time
    end function system_time
  end interface
interface
   subroutine system_srand(seed) bind(c,name='srand')
      import c_int
      integer(kind=c_int),intent(in) :: seed
   end subroutine system_srand
end interface


interface
   function system_kill(c_pid,c_signal) bind(c,name="kill") result(c_ierr)
      import c_int
      integer(kind=c_int),value,intent(in)   :: c_pid
      integer(kind=c_int),value,intent(in)   :: c_signal
      integer(kind=c_int)                    :: c_ierr
   end function
end interface

interface
   integer(kind=c_int) function system_errno() bind (C,name="my_errno")
      import c_int
   end function system_errno
end interface
interface
   integer(kind=c_int) function system_geteuid() bind (C,name="geteuid")
      import c_int
   end function system_geteuid
end interface
interface
   integer(kind=c_int) function system_getuid() bind (C,name="getuid")
      import c_int
   end function system_getuid
end interface
interface
   integer(kind=c_int) function system_getegid() bind (C,name="getegid")
      import c_int
   end function system_getegid
end interface
interface
   integer(kind=c_int) function system_getgid() bind (C,name="getgid")
      import c_int
   end function system_getgid
end interface
interface
   integer(kind=c_int) function system_setsid() bind (C,name="setsid")
      import c_int
   end function system_setsid
end interface
interface
   integer(kind=c_int) function system_getsid(c_pid) bind (C,name="getsid")
      import c_int
      integer(kind=c_int) :: c_pid
   end function system_getsid
end interface

interface
   pure integer(kind=c_int) function system_getpid() bind (C,name="getpid")
      import c_int
   end function system_getpid
end interface
interface
   integer(kind=c_int) function system_getppid() bind (C,name="getppid")
   import c_int
   end function system_getppid
end interface
interface
   integer(kind=c_int) function system_umask(umask_value) bind (C,name="umask")
   import c_int
   integer(kind=c_int),value :: umask_value
   end function system_umask
end interface
interface
   integer(kind=c_int) function system_rand() bind (C,name="rand")
      import c_int
   end function system_rand
end interface
interface
  subroutine c_flush() bind(C,name="my_flush")
  end subroutine c_flush
end interface

integer(kind=c_long),bind(c,name="longest_env_variable") :: longest_env_variable

interface
   subroutine system_initenv() bind (C,NAME='my_initenv')
   end subroutine system_initenv
end interface

integer(kind=mode_t),bind(c,name="FS_IRGRP") ::R_GRP
integer(kind=mode_t),bind(c,name="FS_IROTH") ::R_OTH
integer(kind=mode_t),bind(c,name="FS_IRUSR") ::R_USR
integer(kind=mode_t),bind(c,name="FS_IRWXG") ::RWX_G
integer(kind=mode_t),bind(c,name="FS_IRWXO") ::RWX_O
integer(kind=mode_t),bind(c,name="FS_IRWXU") ::RWX_U
integer(kind=mode_t),bind(c,name="FS_IWGRP") ::W_GRP
integer(kind=mode_t),bind(c,name="FS_IWOTH") ::W_OTH
integer(kind=mode_t),bind(c,name="FS_IWUSR") ::W_USR
integer(kind=mode_t),bind(c,name="FS_IXGRP") ::X_GRP
integer(kind=mode_t),bind(c,name="FS_IXOTH") ::X_OTH
integer(kind=mode_t),bind(c,name="FS_IXUSR") ::X_USR
integer(kind=mode_t),bind(c,name="FDEFFILEMODE") :: DEFFILEMODE
integer(kind=mode_t),bind(c,name="FACCESSPERMS") :: ACCESSPERMS

integer(kind=mode_t),bind(c,name="FHOST_NAME_MAX") :: HOST_NAME_MAX
integer(kind=c_int),parameter           :: F_OK=0
integer(kind=c_int),parameter           :: R_OK=4
integer(kind=c_int),parameter           :: W_OK=2
integer(kind=c_int),parameter           :: X_OK=1
abstract interface                       !  mold for signal handler to be installed by system_signal
   subroutine handler(signum)
   integer :: signum
   end subroutine handler
end interface
type handler_pointer
    procedure(handler), pointer, nopass :: sub
end type handler_pointer
integer, parameter :: no_of_signals=64   !  obtained with command: kill -l
type(handler_pointer), dimension(no_of_signals) :: handler_ptr_array
contains
subroutine system_signal(signum,handler_routine)
integer, intent(in) :: signum
procedure(handler), optional :: handler_routine
type(c_funptr) :: ret,c_handler

interface
   function c_signal(signal, sighandler) bind(c,name='signal')
   import :: c_int,c_funptr
   integer(c_int), value, intent(in) :: signal
   type(c_funptr), value, intent(in) :: sighandler
   type(c_funptr) :: c_signal
   end function c_signal
end interface

if(present(handler_routine))then
    handler_ptr_array(signum)%sub => handler_routine
else
    ! handler_ptr_array(signum)%sub => null(handler_ptr_array(signum)%sub)
    handler_ptr_array(signum)%sub => null()
endif
c_handler=c_funloc(f_handler)
ret=c_signal(signum,c_handler)
end subroutine system_signal

subroutine f_handler(signum) bind(c)
integer(c_int), intent(in), value :: signum
    if(associated(handler_ptr_array(signum)%sub))call handler_ptr_array(signum)%sub(signum)
end subroutine f_handler
elemental impure function system_access(pathname,amode)
implicit none


character(len=*),intent(in) :: pathname
integer,intent(in)          :: amode
logical                     :: system_access

interface
  function c_access(c_pathname,c_amode) bind (C,name="my_access") result (c_ierr)
  import c_char,c_int
  character(kind=c_char,len=1),intent(in) :: c_pathname(*)
  integer(kind=c_int),value               :: c_amode
  integer(kind=c_int)                     :: c_ierr
  end function c_access
end interface

   if(c_access(str2_carr(trim(pathname)),int(amode,kind=c_int)).eq.0)then
      system_access=.true.
   else
      system_access=.false.
    ! if(system_errno().ne.0)then
    !    call perror('*system_access*')
    ! endif
   endif

end function system_access
function system_utime(pathname,times)
implicit none


character(len=*),intent(in) :: pathname
integer,intent(in),optional :: times(2)
integer                     :: times_local(2)
logical                     :: system_utime

interface
  function c_utime(c_pathname,c_times) bind (C,name="my_utime") result (c_ierr)
  import c_char,c_int
  character(kind=c_char,len=1),intent(in) :: c_pathname(*)
  integer(kind=c_int),intent(in)          :: c_times(2)
  integer(kind=c_int)                     :: c_ierr
  end function c_utime
end interface
   if(present(times))then
      times_local=times
   else
      times_local=timestamp()
   endif
   if(c_utime(str2_carr(trim(pathname)),int(times_local,kind=c_int)).eq.0)then
      system_utime=.true.
   else
      system_utime=.false.
      ! if(system_errno().ne.0)then
      !    call perror('*system_utime*')
      ! endif
   endif

end function system_utime
function timestamp() result(epoch)
    use, intrinsic :: iso_c_binding, only: c_long
    implicit none
    integer(kind=8) :: epoch
    interface
        ! time_t time(time_t *tloc)
        function c_time(tloc) bind(c, name='time')
            import :: c_long
            integer(kind=c_long), intent(in), value :: tloc
            integer(kind=c_long)                    :: c_time
        end function c_time
    end interface
    epoch = c_time(int(0, kind=8))
end function timestamp
function system_realpath(input) result(string)


character(len=*),intent(in)    :: input
type(c_ptr)                    :: c_output
character(len=:),allocatable   :: string
interface
   function c_realpath(c_input) bind(c,name="my_realpath") result(c_buffer)
      import c_char, c_size_t, c_ptr, c_int
      character(kind=c_char) ,intent(in)  :: c_input(*)
      type(c_ptr)                         :: c_buffer
   end function
end interface
   c_output=c_realpath(str2_carr(trim(input)))
   if(.not.c_associated(c_output))then
      string=char(0)
   else
      string=C2F_string(c_output)
   endif
end function system_realpath
function system_issock(pathname)
implicit none


character(len=*),intent(in) :: pathname
logical                     :: system_issock

interface
  function c_issock(pathname) bind (C,name="my_issock") result (c_ierr)
  import c_char,c_int
  character(kind=c_char,len=1),intent(in) :: pathname(*)
  integer(kind=c_int)                     :: c_ierr
  end function c_issock
end interface

   if(c_issock(str2_carr(trim(pathname))).eq.1)then
      system_issock=.true.
   else
      system_issock=.false.
   endif

end function system_issock
elemental impure function system_isfifo(pathname)
implicit none


character(len=*),intent(in) :: pathname
logical                     :: system_isfifo

interface
  function c_isfifo(pathname) bind (C,name="my_isfifo") result (c_ierr)
  import c_char,c_int
  character(kind=c_char,len=1),intent(in) :: pathname(*)
  integer(kind=c_int)                     :: c_ierr
  end function c_isfifo
end interface

   if(c_isfifo(str2_carr(trim(pathname))).eq.1)then
      system_isfifo=.true.
   else
      system_isfifo=.false.
   endif

end function system_isfifo
elemental impure function system_ischr(pathname)
implicit none


character(len=*),intent(in) :: pathname
logical                     :: system_ischr

interface
  function c_ischr(pathname) bind (C,name="my_ischr") result (c_ierr)
  import c_char,c_int
  character(kind=c_char,len=1),intent(in) :: pathname(*)
  integer(kind=c_int)                     :: c_ierr
  end function c_ischr
end interface

   if(c_ischr(str2_carr(trim(pathname))).eq.1)then
      system_ischr=.true.
   else
      system_ischr=.false.
   endif

end function system_ischr
elemental impure function system_isreg(pathname)
implicit none


character(len=*),intent(in) :: pathname
logical                     :: system_isreg

interface
  function c_isreg(pathname) bind (C,name="my_isreg") result (c_ierr)
  import c_char,c_int
  character(kind=c_char,len=1),intent(in) :: pathname(*)
  integer(kind=c_int)                     :: c_ierr
  end function c_isreg
end interface

   if(c_isreg(str2_carr(trim(pathname))).eq.1)then
      system_isreg=.true.
   else
      system_isreg=.false.
   endif

end function system_isreg
elemental impure function system_islnk(pathname)
implicit none


character(len=*),intent(in) :: pathname
logical                     :: system_islnk

interface
  function c_islnk(pathname) bind (C,name="my_islnk") result (c_ierr)
  import c_char,c_int
  character(kind=c_char,len=1),intent(in) :: pathname(*)
  integer(kind=c_int)                     :: c_ierr
  end function c_islnk
end interface

   if(c_islnk(str2_carr(trim(pathname))).eq.1)then
      system_islnk=.true.
   else
      system_islnk=.false.
   endif

end function system_islnk
elemental impure function system_isblk(pathname)
implicit none


character(len=*),intent(in) :: pathname
logical                     :: system_isblk

interface
  function c_isblk(pathname) bind (C,name="my_isblk") result (c_ierr)
  import c_char,c_int
  character(kind=c_char,len=1),intent(in) :: pathname(*)
  integer(kind=c_int)                     :: c_ierr
  end function c_isblk
end interface

   if(c_isblk(str2_carr(trim(pathname))).eq.1)then
      system_isblk=.true.
   else
      system_isblk=.false.
   endif

end function system_isblk
elemental impure function system_isdir(dirname)
implicit none


character(len=*),intent(in) :: dirname
logical                     :: system_isdir

interface
  function c_isdir(dirname) bind (C,name="my_isdir") result (c_ierr)
  import c_char,c_int
  character(kind=c_char,len=1),intent(in) :: dirname(*)
  integer(kind=c_int)                     :: c_ierr
  end function c_isdir
end interface

   if(c_isdir(str2_carr(trim(dirname))).eq.1)then
      system_isdir=.true.
   else
      system_isdir=.false.
   endif

end function system_isdir
elemental impure function system_chown(dirname,owner,group)
implicit none


character(len=*),intent(in) :: dirname
integer,intent(in)          :: owner
integer,intent(in)          :: group
logical                     :: system_chown

interface
  function c_chown(c_dirname,c_owner,c_group) bind (C,name="my_chown") result (c_ierr)
  import c_char,c_int
  character(kind=c_char,len=1),intent(in) :: c_dirname(*)
  integer(kind=c_int),intent(in),value    :: c_owner
  integer(kind=c_int),intent(in),value    :: c_group
  integer(kind=c_int)                     :: c_ierr
  end function c_chown
end interface

   if(c_chown(str2_carr(trim(dirname)),int(owner,kind=c_int),int(group,kind=c_int)).eq.1)then
      system_chown=.true.
   else
      system_chown=.false.
   endif

end function system_chown
subroutine system_cpu_time(total,user,system)


real,intent(out)   :: user,system,total
real(kind=c_float) :: c_user,c_system,c_total

interface
   subroutine c_cpu_time(c_total,c_user,c_system) bind (C,NAME='my_cpu_time')
      import c_float
      real(kind=c_float) :: c_total,c_user,c_system
   end subroutine c_cpu_time
end interface

call c_cpu_time(c_total,c_user,c_system)
user=c_user
system=c_system
total=c_total
end subroutine system_cpu_time
elemental impure function system_link(oldname,newname) result(ierr)


character(len=*),intent(in) :: oldname
character(len=*),intent(in) :: newname
integer                     :: ierr
integer(kind=c_int)         :: c_ierr

interface
  function c_link(c_oldname,c_newname) bind (C,name="link") result (c_ierr)
  import c_char,c_int
  character(kind=c_char,len=1),intent(in) :: c_oldname(*)
  character(kind=c_char,len=1),intent(in) :: c_newname(*)
  integer(kind=c_int)                     :: c_ierr
  end function c_link
end interface

   c_ierr=c_link(str2_carr(trim(oldname)),str2_carr(trim(newname)))
   ierr=c_ierr

end function system_link
elemental impure function system_unlink(fname) result (ierr)


character(len=*),intent(in) :: fname
integer                     :: ierr

interface
  function c_unlink(c_fname) bind (C,name="unlink") result (c_ierr)
  import c_char, c_int
  character(kind=c_char,len=1) :: c_fname(*)
  integer(kind=c_int)          :: c_ierr
  end function c_unlink
end interface
   ierr=c_unlink(str2_carr(trim(fname)))
end function system_unlink
integer function system_setumask(umask_value) result (old_umask)
integer,intent(in)  :: umask_value
integer(kind=c_int) :: umask_c

   umask_c=umask_value
   old_umask=system_umask(umask_c) ! set current umask

end function system_setumask
integer function system_getumask() result (umask_value)

integer             :: idum
integer(kind=c_int) :: old_umask
   old_umask=system_umask(0_c_int) ! get current umask but by setting umask to 0 (a conservative mask so no vulnerability is open)
   idum=system_umask(old_umask)    ! set back to original mask
   umask_value=old_umask
end function system_getumask
subroutine system_perror(prefix)
use, intrinsic :: iso_fortran_env, only : ERROR_UNIT, INPUT_UNIT, OUTPUT_UNIT     ! access computing environment


character(len=*),intent(in) :: prefix
   integer                  :: ios

interface
  subroutine c_perror(c_prefix) bind (C,name="perror")
  import c_char
  character(kind=c_char) :: c_prefix(*)
  end subroutine c_perror
end interface

   flush(unit=ERROR_UNIT,iostat=ios)
   flush(unit=OUTPUT_UNIT,iostat=ios)
   flush(unit=INPUT_UNIT,iostat=ios)
   call c_perror(str2_carr((trim(prefix))))
   call c_flush()

end subroutine system_perror
subroutine system_chdir(path, err)


character(len=*)               :: path
integer, optional, intent(out) :: err

interface
   integer(kind=c_int)  function c_chdir(c_path) bind(C,name="chdir")
      import c_char, c_int
      character(kind=c_char)   :: c_path(*)
   end function
end interface
   integer                     :: loc_err
   loc_err=c_chdir(str2_carr(trim(path)))
   if(present(err))then
      err=loc_err
   endif
end subroutine system_chdir
elemental impure function system_remove(path) result(err)


character(*),intent(in) :: path
integer(c_int)          :: err

interface
   function c_remove(c_path) bind(c,name="remove") result(c_err)
      import c_char,c_int
      character(kind=c_char,len=1),intent(in) :: c_path(*)
      integer(c_int)                          :: c_err
   end function
end interface
   err= c_remove(str2_carr(trim(path)))
end function system_remove
function system_rename(input,output) result(ierr)


character(*),intent(in)    :: input,output
integer                    :: ierr
interface
   function c_rename(c_input,c_output) bind(c,name="rename") result(c_err)
      import c_char, c_int
      character(kind=c_char),intent(in) :: c_input(*)
      character(kind=c_char),intent(in) :: c_output(*)
      integer(c_int)                    :: c_err
   end function
end interface
   ierr= c_rename(str2_carr(trim(input)),str2_carr(trim(output)))
end function system_rename
function system_chmod(filename,mode) result(ierr)
   character(len=*),intent(in)  :: filename
   integer,value,intent(in)     :: mode
   integer                      :: ierr
   interface
      function c_chmod(c_filename,c_mode) bind(c,name="chmod") result(c_err)
         import c_char,c_int
         character(kind=c_char),intent(in) :: c_filename(*)
         integer(c_int),value,intent(in)   :: c_mode
         integer(c_int)                    :: c_err
      end function
   end interface
   ierr=c_chmod(str2_carr(trim(filename)),int(mode,kind(0_c_int)))
end function system_chmod
subroutine system_getcwd(output,ierr)


character(len=:),allocatable,intent(out) :: output
integer,intent(out)                      :: ierr
integer(kind=c_long),parameter           :: length=4097_c_long
character(kind=c_char,len=1)             :: buffer(length)
type(c_ptr)                              :: buffer2
interface
   function c_getcwd(buffer,size) bind(c,name="getcwd") result(buffer_result)
      import c_char, c_size_t, c_ptr
      character(kind=c_char) ,intent(out) :: buffer(*)
      integer(c_size_t),value,intent(in)  :: size
      type(c_ptr)                         :: buffer_result
   end function
end interface
   buffer=' '
   buffer2=c_getcwd(buffer,length)
   if(.not.c_associated(buffer2))then
      output=''
      ierr=-1
   else
      output=trim(arr2str(buffer))
      ierr=0
   endif
end subroutine system_getcwd
function system_rmdir(dirname) result(err)


character(*),intent(in) :: dirname
integer(c_int) :: err

interface
   function c_rmdir(c_path) bind(c,name="rmdir") result(c_err)
      import c_char,c_int
      character(kind=c_char,len=1),intent(in) :: c_path(*)
      integer(c_int)                          :: c_err
   end function
end interface
   err= c_rmdir(str2_carr(trim(dirname)))
   if(err.ne.0) err=system_errno()
end function system_rmdir
function system_mkfifo(pathname,mode) result(err)


character(len=*),intent(in)       :: pathname
integer,intent(in)                :: mode
   integer                        :: c_mode
   integer                        :: err

interface
   function c_mkfifo(c_path,c_mode) bind(c,name="mkfifo") result(c_err)
      import c_char, c_int
      character(len=1,kind=c_char),intent(in) :: c_path(*)
      integer(c_int),intent(in),value         :: c_mode
      integer(c_int)                          :: c_err
   end function c_mkfifo
end interface
   c_mode=mode
   err= c_mkfifo(str2_carr(trim(pathname)),c_mode)
end function system_mkfifo
function system_mkdir(dirname,mode) result(ierr)


character(len=*),intent(in)       :: dirname
integer,intent(in)                :: mode
   integer                        :: c_mode
   integer(kind=c_int)            :: err
   integer                        :: ierr

interface
   function c_mkdir(c_path,c_mode) bind(c,name="mkdir") result(c_err)
      import c_char, c_int
      character(len=1,kind=c_char),intent(in) :: c_path(*)
      integer(c_int),intent(in),value         :: c_mode
      integer(c_int)                          :: c_err
   end function c_mkdir
end interface
interface
    subroutine my_mkdir(string,c_mode,c_err) bind(C, name="my_mkdir")
      use iso_c_binding, only : c_char, c_int
      character(kind=c_char) :: string(*)
      integer(c_int),intent(in),value         :: c_mode
      integer(c_int)                          :: c_err
    end subroutine my_mkdir
end interface
   c_mode=mode
   if(index(dirname,'/').ne.0)then
      call my_mkdir(str2_carr(trim(dirname)),c_mode,err)
   else
      err= c_mkdir(str2_carr(trim(dirname)),c_mode)
   endif
   ierr=err                                          ! c_int to default integer kind
end function system_mkdir
subroutine system_opendir(dirname,dir,ierr)
character(len=*), intent(in) :: dirname
type(c_ptr)                  :: dir
integer,intent(out)          :: ierr

interface
   function c_opendir(c_dirname) bind(c,name="opendir") result(c_dir)
      import c_char, c_int, c_ptr
      character(kind=c_char),intent(in) :: c_dirname(*)
      type(c_ptr)                       :: c_dir
   end function c_opendir
end interface

   ierr=0
   dir = c_opendir(str2_carr(trim(dirname)))
   if(.not.c_associated(dir)) then
      write(*,'(a)')'*system_opendir* Error opening '//trim(dirname)
      ierr=-1
   endif

end subroutine system_opendir
subroutine system_readdir(dir,filename,ierr)
type(c_ptr),value                         :: dir
character(len=:),intent(out),allocatable  :: filename
integer,intent(out)                       :: ierr
integer(kind=c_int)                       :: ierr_local

   character(kind=c_char,len=1)           :: buf(4097)

interface
   subroutine c_readdir(c_dir, c_filename,c_ierr) bind (C,NAME='my_readdir')
      import c_char, c_int, c_ptr
      type(c_ptr),value                   :: c_dir
      character(kind=c_char)              :: c_filename(*)
      integer(kind=c_int)                 :: c_ierr
   end subroutine c_readdir
end interface

   buf=' '
   ierr_local=0
   call c_readdir(dir,buf,ierr_local)
   filename=trim(arr2str(buf))
   ierr=ierr_local

end subroutine system_readdir
subroutine system_rewinddir(dir)
type(c_ptr),value            :: dir

interface
   subroutine c_rewinddir(c_dir) bind(c,name="rewinddir")
      import c_char, c_int, c_ptr
      type(c_ptr),value :: c_dir
   end subroutine c_rewinddir
end interface

   call c_rewinddir(dir)

end subroutine system_rewinddir
subroutine system_closedir(dir,ierr)
use iso_c_binding
type(c_ptr),value            :: dir
integer,intent(out),optional :: ierr
   integer                   :: ierr_local

interface
   function c_closedir(c_dir) bind(c,name="closedir") result(c_err)
      import c_char, c_int, c_ptr
      type(c_ptr),value      :: c_dir
      integer(kind=c_int)    :: c_err
   end function c_closedir
end interface

    ierr_local = c_closedir(dir)
    if(present(ierr))then
       ierr=ierr_local
    else
       if(ierr_local /= 0) then
          print *, "*system_closedir* error", ierr_local
          stop 3
       endif
    endif

end subroutine system_closedir
subroutine system_putenv(string, err)


interface
   integer(kind=c_int)  function c_putenv(c_string) bind(C,name="putenv")
      import c_int, c_char
      character(kind=c_char)   :: c_string(*)
   end function
end interface

character(len=*),intent(in)    :: string
integer, optional, intent(out) :: err
   integer                     :: loc_err
   integer                     :: i

   ! PUTENV actually adds the data to the environment so the string passed should be saved or will vanish on exit
   character(len=1,kind=c_char),save, pointer :: memleak(:)

   allocate(memleak(len(string)+1))
   do i=1,len(string)
      memleak(i)=string(i:i)
   enddo
   memleak(len(string)+1)=c_null_char

   loc_err =  c_putenv(memleak)
   if (present(err)) err = loc_err

end subroutine system_putenv
function system_getenv(name,default) result(value)


character(len=*),intent(in)          :: name
character(len=*),intent(in),optional :: default
integer                              :: howbig
integer                              :: stat
character(len=:),allocatable         :: value

   if(NAME.ne.'')then
      call get_environment_variable(name, length=howbig, status=stat, trim_name=.true.)  ! get length required to hold value
      if(howbig.ne.0)then
         select case (stat)
         case (1)     ! print *, NAME, " is not defined in the environment. Strange..."
            value=''
         case (2)     ! print *, "This processor doesn't support environment variables. Boooh!"
            value=''
         case default ! make string to hold value of sufficient size and get value
            if(allocated(value))deallocate(value)
            allocate(character(len=max(howbig,1)) :: VALUE)
            call get_environment_variable(name,value,status=stat,trim_name=.true.)
            if(stat.ne.0)VALUE=''
         end select
      else
         value=''
      endif
   else
      value=''
   endif
   if(value.eq.''.and.present(default))value=default

end function system_getenv
subroutine set_environment_variable(NAME, VALUE, STATUS)


   character(len=*)               :: NAME
   character(len=*)               :: VALUE
   integer, optional, intent(out) :: STATUS
   integer                        :: loc_err

interface
   integer(kind=c_int) function c_setenv(c_name,c_VALUE) bind(C,NAME="setenv")
      import c_int, c_char
      character(kind=c_char)   :: c_name(*)
      character(kind=c_char)   :: c_VALUE(*)
   end function
end interface

   loc_err =  c_setenv(str2_carr(trim(NAME)),str2_carr(VALUE))
   if (present(STATUS)) STATUS = loc_err
end subroutine set_environment_variable
subroutine system_clearenv(ierr)


integer,intent(out),optional    :: ierr
   character(len=:),allocatable :: string
   integer                      :: ierr_local1, ierr_local2
   ierr_local2=0
   INFINITE: do
      call system_initenv()                     ! important -- changing table causes undefined behavior so reset after each unsetenv
      string=system_readenv()                                           ! get first name=value pair
      if(string.eq.'') exit INFINITE
      call system_unsetenv(string(1:index(string,'=')-1) ,ierr_local1)  ! remove first name=value pair
      if(ierr_local1.ne.0)ierr_local2=ierr_local1
   enddo INFINITE
   if(present(ierr))then
      ierr=ierr_local2
   elseif(ierr_local2.ne.0)then                                         ! if error occurs and not being returned, stop
      write(*,*)'*system_clearenv* error=',ierr_local2
      stop
   endif
end subroutine system_clearenv
subroutine system_unsetenv(name,ierr)


character(len=*),intent(in)  :: name
integer,intent(out),optional :: ierr
   integer                   :: ierr_local

interface
   integer(kind=c_int) function c_unsetenv(c_name) bind(C,NAME="unsetenv")
   import c_int, c_char
   character(len=1,kind=c_char) :: c_name(*)
   end function
end interface

   ierr_local =  c_unsetenv(str2_carr(trim(NAME)))

   if(present(ierr))then
      ierr=ierr_local
   elseif(ierr_local.ne.0)then ! if error occurs and not being returned, stop
      write(*,*)'*system_unsetenv* error=',ierr_local
      stop
   endif

end subroutine system_unsetenv
function system_readenv() result(string)


character(len=:),allocatable  :: string
character(kind=c_char)        :: c_buff(longest_env_variable+1)

interface
   subroutine c_readenv(c_string) bind (C,NAME='my_readenv')
      import c_char, c_int, c_ptr, c_size_t
      character(kind=c_char),intent(out)  :: c_string(*)
   end subroutine c_readenv
end interface

  c_buff=' '
  c_buff(longest_env_variable+1:longest_env_variable+1)=c_null_char
  call c_readenv(c_buff)
  string=trim(arr2str(c_buff))

end function system_readenv
subroutine fileglob(glob, list) ! NON-PORTABLE AT THIS POINT. REQUIRES ls(1) command, assumes 1 line per file
implicit none


character(len=*),intent(in)   :: glob                   ! Pattern for the filenames (like: *.txt)
character(len=*),pointer      :: list(:)                ! Allocated list of filenames (returned), the caller must deallocate it.
   character(len=255)            :: tmpfile             ! scratch filename to hold expanded file list
   character(len=255)            :: cmd                 ! string to build system command in
   integer                       :: iotmp               ! needed to open unique scratch file for holding file list
   integer                       :: i,ios,icount
   write(tmpfile,'(*(g0))')'/tmp/__filelist_',timestamp(),'_',system_getpid() ! preliminary scratch file name
   cmd='ls -d '//trim(glob)//'>'//trim(tmpfile)//' '    ! build command string
   call execute_command_line(cmd )                      ! Execute the command specified by the string.
   open(newunit=iotmp,file=tmpfile,iostat=ios)          ! open unique scratch filename
   if(ios.ne.0) return                                  ! the open failed
   icount=0                                             ! number of filenames in expanded list
   do                                                   ! count the number of lines (assumed ==files) so know what to allocate
       read(iotmp,'(a)', iostat=ios)                    ! move down a line in the file to count number of lines
       if(ios .ne. 0)exit                               ! hopefully, this is because end of file was encountered so done
       icount=icount+1                                  ! increment line count
   enddo
   rewind(iotmp)                                        ! rewind file list so can read and store it
   allocate(list(icount))                               ! allocate and fill the array
   do i=1,icount
      read(iotmp,'(a)')list(i)                          ! read a filename from a line
   enddo
   close(iotmp, status='delete',iostat=ios)             ! close and delete scratch file
end subroutine fileglob
subroutine system_uname(WHICH,NAMEOUT)
implicit none


character(KIND=C_CHAR),intent(in) :: WHICH
character(len=*),intent(out)      :: NAMEOUT

interface
   subroutine system_uname_c(WHICH,BUF,BUFLEN) bind(C,NAME='my_uname')
      import c_char, c_int
      implicit none
      character(KIND=C_CHAR),intent(in)  :: WHICH
      character(KIND=C_CHAR),intent(out) :: BUF(*)
      integer(kind=c_int),intent(in)     :: BUFLEN
   end subroutine system_uname_c
end interface

   NAMEOUT='unknown'
   call system_uname_c(WHICH,NAMEOUT, INT(LEN(NAMEOUT),kind(0_c_int)))

end subroutine system_uname
subroutine system_gethostname(NAME,IERR)
implicit none


character(len=:),allocatable,intent(out) :: NAME
integer,intent(out)                      :: IERR
   character(kind=c_char,len=1)          :: C_BUFF(HOST_NAME_MAX+1)

interface
   function system_gethostname_c(c_buf,c_buflen) bind(C,NAME='gethostname')
      import c_char, c_int
      implicit none
      integer(kind=c_int)                  :: system_gethostname_c
      character(KIND=C_CHAR),intent(out)   :: c_buf(*)
      integer(kind=c_int),intent(in),value :: c_buflen
   end function system_gethostname_c
end interface

   C_BUFF=' '
   ierr=system_gethostname_c(C_BUFF,HOST_NAME_MAX) ! Host names are limited to {HOST_NAME_MAX} bytes.
   NAME=trim(arr2str(C_BUFF))

end subroutine system_gethostname
function system_getlogin() result (fname)
character(len=:),allocatable :: fname
   type(c_ptr)               :: username

interface
   function c_getlogin() bind(c,name="getlogin") result(c_username)
      import c_int, c_ptr
      type(c_ptr)           :: c_username
   end function c_getlogin
end interface

   username = c_getlogin()
   if(.not.c_associated(username)) then
      !  in windows 10 subsystem running Ubunto does not work
      ! write(*,'(a)')'*system_getlogin* Error getting username. not associated'
      ! fname=c_null_char
      fname=system_getpwuid(system_geteuid())
   else
      fname=c2f_string(username)
   endif

end function system_getlogin
function system_perm(mode) result (perms)
class(*),intent(in)          :: mode
character(len=:),allocatable :: perms
   type(c_ptr)               :: permissions
   integer(kind=c_long)      :: mode_local
interface
   function c_perm(c_mode) bind(c,name="my_get_perm") result(c_permissions)
      import c_int, c_ptr, c_long
      integer(kind=c_long),value  :: c_mode
      type(c_ptr)                 :: c_permissions
   end function c_perm
end interface

   mode_local=int(anyinteger_to_64bit(mode),kind=c_long)
   permissions = c_perm(mode_local)
   if(.not.c_associated(permissions)) then
      write(*,'(a)')'*system_perm* Error getting permissions. not associated'
      perms=c_null_char
   else
      perms=c2f_string(permissions)
   endif

end function system_perm
function system_getgrgid(gid) result (gname)
class(*),intent(in)                        :: gid
character(len=:),allocatable               :: gname
   character(kind=c_char,len=1)            :: groupname(4097)  ! assumed long enough for any groupname
   integer                                 :: ierr
   integer(kind=c_long_long)               :: gid_local

interface
   function c_getgrgid(c_gid,c_groupname) bind(c,name="my_getgrgid") result(c_ierr)
      import c_int, c_ptr, c_char,c_long_long
      integer(kind=c_long_long),value,intent(in) :: c_gid
      character(kind=c_char),intent(out)         :: c_groupname(*)
      integer(kind=c_int)                        :: c_ierr
   end function c_getgrgid
end interface
   gid_local=anyinteger_to_64bit(gid)
   ierr = c_getgrgid(gid_local,groupname)
   if(ierr.eq.0)then
      gname=trim(arr2str(groupname))
   else
      gname=''
   endif
end function system_getgrgid
function system_getpwuid(uid) result (uname)
class(*),intent(in)                        :: uid
character(len=:),allocatable               :: uname
   character(kind=c_char,len=1)            :: username(4097)  ! assumed long enough for any username
   integer                                 :: ierr
   integer(kind=c_long_long)               :: uid_local

interface
   function c_getpwuid(c_uid,c_username) bind(c,name="my_getpwuid") result(c_ierr)
      import c_int, c_ptr, c_char, c_long_long
      integer(kind=c_long_long),value,intent(in) :: c_uid
      character(kind=c_char),intent(out)   :: c_username(*)
      integer(kind=c_int)                  :: c_ierr
   end function c_getpwuid
end interface
   uid_local=anyinteger_to_64bit(uid)
   ierr = c_getpwuid(uid_local,username)
   if(ierr.eq.0)then
      uname=trim(arr2str(username))
   else
      uname=''
   endif
end function system_getpwuid
pure function arr2str(array)  result (string)


character(len=1),intent(in)  :: array(:)
character(len=size(array))   :: string
integer                      :: i

   string=' '
   do i = 1,size(array)
      if(array(i).eq.char(0))then
         exit
      else
         string(i:i) = array(i)
      endif
   enddo

end function arr2str
pure function str2_carr(string) result (array)


character(len=*),intent(in)     :: string
character(len=1,kind=c_char)    :: array(len(string)+1)
   integer                      :: i

   do i = 1,len_trim(string)
      array(i) = string(i:i)
   enddo
   array(i:i)=c_null_char

end function str2_carr
function C2F_string(c_string_pointer) result(f_string)


type(c_ptr), intent(in)                       :: c_string_pointer
character(len=:), allocatable                 :: f_string
character(kind=c_char), dimension(:), pointer :: char_array_pointer => null()
integer,parameter                             :: max_len=4096
character(len=max_len)                        :: aux_string
integer                                       :: i
integer                                       :: length

   length=0
   call c_f_pointer(c_string_pointer,char_array_pointer,[max_len])

   if (.not.associated(char_array_pointer)) then
     if(allocated(f_string))deallocate(f_string)
     allocate(character(len=4)::f_string)
     f_string=c_null_char
     return
   endif

   aux_string=" "

   do i=1,max_len
     if (char_array_pointer(i)==c_null_char) then
       length=i-1; exit
     endif
     aux_string(i:i)=char_array_pointer(i)
   enddo

   if(allocated(f_string))deallocate(f_string)
   allocate(character(len=length)::f_string)
   f_string=aux_string(1:length)
end function C2F_string
subroutine system_stat(pathname,values,ierr)
implicit none


character(len=*),intent(in)          :: pathname

integer(kind=int64),intent(out)      :: values(13)
integer(kind=c_long)                 :: cvalues(13)

integer,optional,intent(out)         :: ierr
integer(kind=c_int)                  :: cierr

interface
   subroutine c_stat(buffer,cvalues,cierr,cdebug) bind(c,name="my_stat")
      import c_char, c_size_t, c_ptr, c_int, c_long
      character(kind=c_char),intent(in)   :: buffer(*)
      integer(kind=c_long),intent(out)    :: cvalues(*)
      integer(kind=c_int)                 :: cierr
      integer(kind=c_int),intent(in)      :: cdebug
   end subroutine c_stat
end interface
   call c_stat(str2_carr(trim(pathname)),cvalues,cierr,0_c_int)
   values=cvalues
   if(present(ierr))then
      ierr=cierr
   endif
end subroutine system_stat
function system_dir(directory,pattern)
use iso_c_binding
implicit none
character(len=*),intent(in),optional  :: directory
character(len=*),intent(in),optional  :: pattern
character(len=:),allocatable          :: system_dir(:)
character(len=:),allocatable          :: wild
type(c_ptr)                           :: dir
character(len=:),allocatable          :: filename
integer                               :: i, ierr, icount, longest
   longest=0
   icount=0
   if(present(pattern))then
      wild=pattern
   else
      wild='*'
   endif
   if(present(directory))then                        !--- open directory stream to read from
      call system_opendir(directory, dir, ierr)
   else
      call system_opendir('.', dir, ierr)
   endif
   if(ierr.eq.0)then
      do i=1, 2                                      !--- read directory stream twice, first time to get size
         do
            call system_readdir(dir, filename, ierr)
            if(filename.eq.' ')exit
            if(wild.ne.'*')then
              if(.not.matchw(filename, wild))cycle   ! Call a wildcard matching routine.
            endif
            icount=icount+1
            select case(i)
            case(1)
               longest=max(longest, len(filename))
            case(2)
               system_dir(icount)=filename
            end select
         enddo
         if(i.eq.1)then
            call system_rewinddir(dir)
            if(allocated(system_dir))deallocate(system_dir)
            allocate(character(len=longest) :: system_dir(icount))
            icount=0
         endif
      enddo
   endif
   call system_closedir(dir, ierr)                   !--- close directory stream
end function system_dir
function matchw(tame,wild)


logical                    :: matchw
character(len=*)           :: tame       ! A string without wildcards
character(len=*)           :: wild       ! A (potentially) corresponding string with wildcards
character(len=len(tame)+1) :: tametext
character(len=len(wild)+1) :: wildtext
character(len=1),parameter :: NULL=char(0)
integer                    :: wlen
integer                    :: ti, wi
integer                    :: i
character(len=:),allocatable :: tbookmark, wbookmark
   tametext=tame//NULL
   wildtext=wild//NULL
   tbookmark = NULL
   wbookmark = NULL
   wlen=len(wild)
   wi=1
   ti=1
   do                                            ! Walk the text strings one character at a time.
      if(wildtext(wi:wi) == '*')then             ! How do you match a unique text string?
         do i=wi,wlen                            ! Easy: unique up on it!
            if(wildtext(wi:wi).eq.'*')then
               wi=wi+1
            else
               exit
            endif
         enddo
         if(wildtext(wi:wi).eq.NULL) then        ! "x" matches "*"
            matchw=.true.
            return
         endif
         if(wildtext(wi:wi) .ne. '?') then
            ! Fast-forward to next possible match.
            do while (tametext(ti:ti) .ne. wildtext(wi:wi))
               ti=ti+1
               if (tametext(ti:ti).eq.NULL)then
                  matchw=.false.
                  return                         ! "x" doesn't match "*y*"
               endif
            enddo
         endif
         wbookmark = wildtext(wi:)
         tbookmark = tametext(ti:)
      elseif(tametext(ti:ti) .ne. wildtext(wi:wi) .and. wildtext(wi:wi) .ne. '?') then
         ! Got a non-match. If we've set our bookmarks, back up to one or both of them and retry.
         if(wbookmark.ne.NULL) then
            if(wildtext(wi:).ne. wbookmark) then
               wildtext = wbookmark;
               wlen=len_trim(wbookmark)
               wi=1
               ! Don't go this far back again.
               if (tametext(ti:ti) .ne. wildtext(wi:wi)) then
                  tbookmark=tbookmark(2:)
                  tametext = tbookmark
                  ti=1
                  cycle                          ! "xy" matches "*y"
               else
                  wi=wi+1
               endif
            endif
            if (tametext(ti:ti).ne.NULL) then
               ti=ti+1
               cycle                             ! "mississippi" matches "*sip*"
            endif
         endif
         matchw=.false.
         return                                  ! "xy" doesn't match "x"
      endif
      ti=ti+1
      wi=wi+1
      if (tametext(ti:ti).eq.NULL) then          ! How do you match a tame text string?
         if(wildtext(wi:wi).ne.NULL)then
            do while (wildtext(wi:wi) == '*')    ! The tame way: unique up on it!
               wi=wi+1                           ! "x" matches "x*"
               if(wildtext(wi:wi).eq.NULL)exit
            enddo
         endif
         if (wildtext(wi:wi).eq.NULL)then
            matchw=.true.
            return                               ! "x" matches "x"
         endif
         matchw=.false.
         return                                  ! "x" doesn't match "xy"
      endif
   enddo
end function matchw
pure elemental function anyinteger_to_64bit(intin) result(ii38)
use, intrinsic :: iso_fortran_env, only : error_unit !  ,input_unit,output_unit
implicit none


class(*),intent(in)     :: intin
   integer(kind=int64) :: ii38
   select type(intin)
   type is (integer(kind=int8));   ii38=int(intin,kind=int64)
   type is (integer(kind=int16));  ii38=int(intin,kind=int64)
   type is (integer(kind=int32));  ii38=intin
   type is (integer(kind=int64));  ii38=intin
   !class default
      !write(error_unit,*)'ERROR: unknown integer type'
      !stop 'ERROR: *anyinteger_to_64* unknown integer type'
   end select
end function anyinteger_to_64bit
end module M_system
