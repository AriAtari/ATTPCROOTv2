################################################################################
#    Copyright (C) 2014 GSI Helmholtzzentrum fuer Schwerionenforschung GmbH    #
#                                                                              #
#              This software is distributed under the terms of the             #
#              GNU Lesser General Public Licence (LGPL) version 3,             #
#                  copied verbatim in the file "LICENSE"                       #
################################################################################
# Based on the FindPackage2 macro introduced by FairRoot

################################################################################
#
# find_package2(PRIVATE|PUBLIC|INTERFACE <pkgname>
#               [VERSION <version>]
#               [COMPONENTS <list of components>]
#               [OPTIONAL_COMPONENTS <list of components>]
#               [ADD_REQUIREMENTS_OF <list of dep_pgkname>]
#               [FIND_DEPENDENCIES [EXCEPT <list of dep_pgkname>]
#               [any other option the native find_package supports]...)
#
# Wrapper around CMake's native find_package command to add some features and bookkeeping.
#
# The qualifier (PRIVATE|PUBLIC|INTERFACE) to the package to populate
# the variables PROJECT_[INTERFACE]_<pkgname>_([VERSION]|[COMPONENTS]|PACKAGE_DEPENDENCIES)
# accordingly. If a package is not found, it is added to the list PROJECT_PACKAGE_NOT_FOUND.
# This bookkeeping information is used to print our dependency found summary table and to generate
# a part of our CMake package.
#
# When a dependending package is listed with ADD_REQUIREMENTS_OF the variables
# <dep_pkgname>_<pkgname>_VERSION|COMPONENTS are looked up to and added to the native
# VERSION (selected highest version) and COMPONENTS (deduplicated) args.
#
# COMPONENTS, OPTIONAL_COMPONENTS, VERSION args are then just passed to the native find_package.
#
# If <pkgname> is found, FIND_DEPENDENCIES loops over the <pkgname>_PACKAGE_DEPENDENCIES list and
# calls find_package2 on each list item recursively. The loop will skip any item listed in the
# EXCEPT argument. ADD_REQUIREMENTS_OF args will be passed to each recursive find_package2 call.

macro(find_package2 qualifier pkgname)
  cmake_parse_arguments(ARGS "FIND_DEPENDENCIES" "VERSION" "COMPONENTS;ADD_REQUIREMENTS_OF;OPTIONAL_COMPONENTS;EXCEPT" ${ARGN})

  string(TOUPPER ${pkgname} pkgname_upper)
  set(__old_cpp__ ${CMAKE_PREFIX_PATH})
  set(CMAKE_PREFIX_PATH ${${pkgname_upper}_ROOT} $ENV{${pkgname_upper}_ROOT} ${CMAKE_PREFIX_PATH})

  # build lists of required versions and components
  unset(__required_versions__)
  unset(__components__)
  unset(__optional_components__)
  if(ARGS_VERSION)
    list(APPEND __required_versions__ ${ARGS_VERSION})
  endif()
  if(ARGS_COMPONENTS)
    list(APPEND __components__ ${ARGS_COMPONENTS})
  endif()
  if(ARGS_OPTIONAL_COMPONENTS)
    list(APPEND __optional_components__ ${ARGS_OPTIONAL_COMPONENTS})
  endif()
  
  if(ARGS_ADD_REQUIREMENTS_OF)
    foreach(dep_pkgname IN LISTS ARGS_ADD_REQUIREMENTS_OF)
      if(${dep_pkgname}_${pkgname}_VERSION)
        list(APPEND __required_versions__ ${${dep_pkgname}_${pkgname}_VERSION})
      endif()
      if(${dep_pkgname}_${pkgname}_COMPONENTS)
        list(APPEND __components__ ${${dep_pkgname}_${pkgname}_COMPONENTS})
      endif()
      if(${dep_pkgname}_${pkgname}_OPTIONAL_COMPONENTS)
        list(APPEND __optional_components__ ${${dep_pkgname}_${pkgname}_OPTIONAL_COMPONENTS})
      endif()
    endforeach()
  endif()

  # select highest required version
  unset(__version__)
  if(__required_versions__)
    list(GET __required_versions__ 0 __version__)
    foreach(v IN LISTS __required_versions__)
      if(${v} VERSION_GREATER ${__version__})
        set(__version__ ${v})
      endif()
    endforeach()
  endif()
  # deduplicate required component list
  if(__components__)
    list(REMOVE_DUPLICATES __components__)
  endif()


  # call native find_package
  if(__components__ AND __optional_components__)
    find_package(${pkgname} ${__version__} QUIET
      COMPONENTS ${__components__}
      OPTIONAL_COMPONENTS ${__optional_components__} ${ARGS_UNPARSED_ARGUMENTS})
  elseif(__components__ AND NOT __optional_components__)
    find_package(${pkgname} ${__version__} QUIET
      COMPONENTS ${__components__} ${ARGS_UNPARSED_ARGUMENTS})
  elseif(NOT __components__ AND __optional_components__)
    find_package(${pkgname} ${__version__} QUIET
      OPTIONAL_COMPONENTS ${__optional_components__} ${ARGS_UNPARSED_ARGUMENTS})
  else()
    find_package(${pkgname} ${__version__} QUIET ${ARGS_UNPARSED_ARGUMENTS})
  endif()
  
  if(${pkgname}_FOUND)
    if(${qualifier} STREQUAL PRIVATE)
      set(PROJECT_${pkgname}_VERSION ${__version__})
      set(PROJECT_${pkgname}_COMPONENTS ${__components__})
      set(PROJECT_${pkgname}_OPTIONAL_COMPONENTS ${__optional_components__})
      set(PROJECT_PACKAGE_DEPENDENCIES ${PROJECT_PACKAGE_DEPENDENCIES} ${pkgname})
    elseif(${qualifier} STREQUAL PUBLIC)
      set(PROJECT_${pkgname}_VERSION ${__version__})
      set(PROJECT_${pkgname}_COMPONENTS ${__components__})
      set(PROJECT_${pkgname}_OPTIONAL_COMPONENTS ${__optional_components__})
      set(PROJECT_PACKAGE_DEPENDENCIES ${PROJECT_PACKAGE_DEPENDENCIES} ${pkgname})
      set(PROJECT_INTERFACE_${pkgname}_VERSION ${__version__})
      set(PROJECT_INTERFACE_${pkgname}_COMPONENTS ${__components__})
      set(PROJECT_INTERFACE_${pkgname}_OPTIONAL_COMPONENTS ${__optional_components__})
      set(PROJECT_INTERFACE_PACKAGE_DEPENDENCIES ${PROJECT_INTERFACE_PACKAGE_DEPENDENCIES} ${pkgname})
    elseif(${qualifier} STREQUAL INTERFACE)
      set(PROJECT_INTERFACE_${pkgname}_VERSION ${__version__})
      set(PROJECT_INTERFACE_${pkgname}_COMPONENTS ${__components__})
      set(PROJECT_INTERFACE_${pkgname}_OPTIONAL_COMPONENTS ${__optional_components__})
      set(PROJECT_INTERFACE_PACKAGE_DEPENDENCIES ${PROJECT_INTERFACE_PACKAGE_DEPENDENCIES} ${pkgname})
    endif()
  else(${pkgname}_FOUND)
    list(APPEND PROJECT_PACKAGE_NOT_FOUND ${pkgname})
  endif(${pkgname}_FOUND)

  # Remove dups from global project dependecy list
  if(PROJECT_PACKAGE_DEPENDENCIES)
    list(REMOVE_DUPLICATES PROJECT_PACKAGE_DEPENDENCIES)
  endif()
  if(PROJECT_INTERFACE_PACKAGE_DEPENDENCIES)
    list(REMOVE_DUPLICATES PROJECT_INTERFACE_PACKAGE_DEPENDENCIES)
  endif()
  if(PROJECT_PACKAGE_NOT_FOUND)
    list(REMOVE_DUPLICATES PROJECT_PACKAGE_NOT_FOUND)
  endif()

  unset(__required_versions__)
  unset(__components__)
  unset(__optional_components__)
  unset(__required_versions__)
  set(CMAKE_PREFIX_PATH ${__old_cpp__})
  unset(__old_cpp__)

  # Recursively call for FIND_DEPENDENCIES
  if(${pkgname}_FOUND AND ARGS_FIND_DEPENDENCIES)
    foreach(dep IN LISTS ${pkgname}_PACKAGE_DEPENDENCIES)
      if(NOT dep IN_LIST ARGS_EXCEPT)
	set(__exceptions__ ${ARGS_EXCEPT} ${pkgname}_PACKAGE_DEPENDENCIES)
	if(__exceptions__)
	  list(REMOVE_DUPLICATES __exceptions__)
	  find_package2(${qualifier} ${dep} REQUIRED
	    ADD_REQUIREMENTS_OF ${PROJECT_PACKAGE_DEPENDENCIES}
	    FIND_DEPENDENCIES EXCEPT ${__exceptions__})
	else()
	  find_package2(${qualifier} ${dep} REQUIRED
	    ADD_REQUIREMENTS_OF ${PROJECT_PACKAGE_DEPENDENCIES}
	    FIND_DEPENDENCIES)
	endif()
      endif()
    endforeach()
  endif()
  
endmacro()

