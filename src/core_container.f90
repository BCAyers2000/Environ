!----------------------------------------------------------------------------------------
!
! Copyright (C) 2018-2022 ENVIRON (www.quantum-environ.org)
!
!----------------------------------------------------------------------------------------
!
!     This file is part of Environ version 3.0
!
!     Environ 3.0 is free software: you can redistribute it and/or modify
!     it under the terms of the GNU General Public License as published by
!     the Free Software Foundation, either version 2 of the License, or
!     (at your option) any later version.
!
!     Environ 3.0 is distributed in the hope that it will be useful,
!     but WITHOUT ANY WARRANTY; without even the implied warranty of
!     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!     GNU General Public License for more detail, either the file
!     `License' in the root directory of the present distribution, or
!     online at <http://www.gnu.org/licenses/>.
!
!----------------------------------------------------------------------------------------
!
! Authors: Oliviero Andreussi (Department of Physics, UNT)
!          Edan Bainglass     (Department of Physics, UNT)
!
!----------------------------------------------------------------------------------------
!>
!!
!----------------------------------------------------------------------------------------
MODULE class_core_container
    !------------------------------------------------------------------------------------
    !
    USE class_io, ONLY: io
    !
    USE class_core
    !
    !------------------------------------------------------------------------------------
    !
    IMPLICIT NONE
    !
    PRIVATE
    !
    !------------------------------------------------------------------------------------
    !>
    !!
    !------------------------------------------------------------------------------------
    TYPE, PUBLIC :: core_container
        !--------------------------------------------------------------------------------
        !
        CHARACTER(LEN=80) :: label = ''
        !
        LOGICAL :: internal_correction = .FALSE.
        !
        LOGICAL :: has_derivatives = .FALSE.
        CLASS(environ_core), POINTER :: derivatives => NULL()
        !
        LOGICAL :: has_electrostatics = .FALSE.
        CLASS(environ_core), POINTER :: electrostatics => NULL()
        !
        LOGICAL :: has_corrections = .FALSE.
        CLASS(environ_core), POINTER :: corrections => NULL()
        !
        !--------------------------------------------------------------------------------
    CONTAINS
        !--------------------------------------------------------------------------------
        !
        PROCEDURE, PRIVATE :: create => create_core_container
        PROCEDURE :: init => init_core_container
        PROCEDURE :: destroy => destroy_core_container
        !
        PROCEDURE :: set_derivatives
        PROCEDURE :: set_electrostatics
        PROCEDURE :: set_corrections
        !
        !--------------------------------------------------------------------------------
    END TYPE core_container
    !------------------------------------------------------------------------------------
    !
    !------------------------------------------------------------------------------------
CONTAINS
    !------------------------------------------------------------------------------------
    !------------------------------------------------------------------------------------
    !
    !                                   ADMIN METHODS
    !
    !------------------------------------------------------------------------------------
    !------------------------------------------------------------------------------------
    !>
    !!
    !------------------------------------------------------------------------------------
    SUBROUTINE create_core_container(this)
        !--------------------------------------------------------------------------------
        !
        IMPLICIT NONE
        !
        CLASS(core_container), INTENT(INOUT) :: this
        !
        CHARACTER(LEN=80) :: routine = 'create_core_container'
        !
        !--------------------------------------------------------------------------------
        !
        IF (ASSOCIATED(this%derivatives)) CALL io%create_error(routine)
        !
        IF (ASSOCIATED(this%electrostatics)) CALL io%create_error(routine)
        !
        IF (ASSOCIATED(this%corrections)) CALL io%create_error(routine)
        !
        !--------------------------------------------------------------------------------
        !
        this%label = ''
        this%internal_correction = .FALSE.
        this%has_derivatives = .FALSE.
        this%has_electrostatics = .FALSE.
        this%has_corrections = .FALSE.
        !
        NULLIFY (this%derivatives)
        NULLIFY (this%electrostatics)
        NULLIFY (this%corrections)
        !
        !--------------------------------------------------------------------------------
    END SUBROUTINE create_core_container
    !------------------------------------------------------------------------------------
    !>
    !!
    !------------------------------------------------------------------------------------
    SUBROUTINE init_core_container(this, label, deriv_core, elect_core, corr_core, &
                                   inter_corr)
        !--------------------------------------------------------------------------------
        !
        IMPLICIT NONE
        !
        CHARACTER(LEN=*), INTENT(IN) :: label
        CLASS(environ_core), OPTIONAL, INTENT(IN) :: deriv_core
        CLASS(environ_core), OPTIONAL, INTENT(IN) :: elect_core
        CLASS(environ_core), OPTIONAL, INTENT(IN) :: corr_core
        LOGICAL, OPTIONAL, INTENT(IN) :: inter_corr
        !
        CLASS(core_container), INTENT(INOUT) :: this
        !
        CHARACTER(LEN=80) :: routine = 'init_core_container'
        !
        !--------------------------------------------------------------------------------
        !
        CALL this%create()
        !
        this%label = label
        !
        IF (PRESENT(elect_core)) CALL this%set_electrostatics(elect_core)
        !
        IF (PRESENT(deriv_core)) CALL this%set_derivatives(deriv_core)
        !
        IF (PRESENT(corr_core)) CALL this%set_corrections(corr_core)
        !
        IF (PRESENT(inter_corr)) this%internal_correction = inter_corr
        !
        !--------------------------------------------------------------------------------
    END SUBROUTINE init_core_container
    !------------------------------------------------------------------------------------
    !>
    !!
    !------------------------------------------------------------------------------------
    SUBROUTINE destroy_core_container(this)
        !--------------------------------------------------------------------------------
        !
        IMPLICIT NONE
        !
        CLASS(core_container), INTENT(INOUT) :: this
        !
        CHARACTER(LEN=80) :: routine = 'destroy_core_container'
        !
        !--------------------------------------------------------------------------------
        !
        IF (ASSOCIATED(this%derivatives)) THEN
            !
            CALL this%derivatives%destroy()
            !
            NULLIFY (this%derivatives)
        END IF
        !
        IF (ASSOCIATED(this%electrostatics)) THEN
            !
            CALL this%electrostatics%destroy()
            !
            NULLIFY (this%electrostatics)
        END IF
        !
        IF (ASSOCIATED(this%corrections)) THEN
            !
            CALL this%corrections%destroy()
            !
            NULLIFY (this%corrections)
        END IF
        !
        !--------------------------------------------------------------------------------
    END SUBROUTINE destroy_core_container
    !------------------------------------------------------------------------------------
    !>
    !!
    !------------------------------------------------------------------------------------
    SUBROUTINE set_derivatives(this, core)
        !--------------------------------------------------------------------------------
        !
        IMPLICIT NONE
        !
        CLASS(environ_core), TARGET, INTENT(IN) :: core
        !
        CLASS(core_container), INTENT(INOUT) :: this
        !
        CHARACTER(LEN=80) :: routine = 'set_derivatives'
        !
        !--------------------------------------------------------------------------------
        !
        IF (ASSOCIATED(this%derivatives)) CALL io%create_error(routine)
        !
        !--------------------------------------------------------------------------------
        !
        this%derivatives => core
        this%has_derivatives = .TRUE.
        !
        !--------------------------------------------------------------------------------
    END SUBROUTINE set_derivatives
    !------------------------------------------------------------------------------------
    !>
    !!
    !------------------------------------------------------------------------------------
    SUBROUTINE set_electrostatics(this, core)
        !--------------------------------------------------------------------------------
        !
        IMPLICIT NONE
        !
        CLASS(environ_core), TARGET, INTENT(IN) :: core
        !
        CLASS(core_container), INTENT(INOUT) :: this
        !
        CHARACTER(LEN=80) :: routine = 'set_electrostatics'
        !
        !--------------------------------------------------------------------------------
        !
        IF (ASSOCIATED(this%electrostatics)) CALL io%create_error(routine)
        !
        !--------------------------------------------------------------------------------
        !
        this%electrostatics => core
        this%has_electrostatics = .TRUE.
        !
        !--------------------------------------------------------------------------------
    END SUBROUTINE set_electrostatics
    !------------------------------------------------------------------------------------
    !>
    !!
    !------------------------------------------------------------------------------------
    SUBROUTINE set_corrections(this, core)
        !--------------------------------------------------------------------------------
        !
        IMPLICIT NONE
        !
        CLASS(environ_core), TARGET, INTENT(IN) :: core
        !
        CLASS(core_container), INTENT(INOUT) :: this
        !
        CHARACTER(LEN=80) :: routine = 'set_corrections'
        !
        !--------------------------------------------------------------------------------
        !
        IF (ASSOCIATED(this%corrections)) CALL io%create_error(routine)
        !
        !--------------------------------------------------------------------------------
        !
        this%corrections => core
        this%has_corrections = .TRUE.
        !
        !--------------------------------------------------------------------------------
    END SUBROUTINE set_corrections
    !------------------------------------------------------------------------------------
    !
    !------------------------------------------------------------------------------------
END MODULE class_core_container
!----------------------------------------------------------------------------------------
