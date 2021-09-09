# Helper CMAKE wrapper functions 

function(age_include_cmake_file_list file)
    
    set(UNITY_AUTO_EXCLUSIONS)
    
    include(${file})
    get_filename_component(file_path "${file}" PATH)
    if(file_path)
        list(TRANSFORM FILES PREPEND ${file_path}/)
    endif()
    foreach(f ${FILES})
        get_filename_component(absolute_path ${f} ABSOLUTE)
        if(NOT EXISTS ${absolute_path})
            message(SEND_ERROR "File ${absolute_path} referenced in ${file} not found")
        endif()
        
        # Automatically exclude any extensions marked for the current platform
        if (PAL_TRAIT_BUILD_UNITY_EXCLUDE_EXTENSIONS)
            get_filename_component(file_extension ${f} LAST_EXT)
            if (${file_extension} IN_LIST PAL_TRAIT_BUILD_UNITY_EXCLUDE_EXTENSIONS)
                list(APPEND UNITY_AUTO_EXCLUSIONS ${f})
            endif()
        endif()
    
    endforeach()
    list(APPEND FILES ${file}) # Add the _files.cmake to the list so it shows in the IDE
    
    if(file_path)
        list(TRANSFORM SKIP_UNITY_BUILD_INCLUSION_FILES PREPEND ${file_path}/)
    endif()
    
    # Check if there are any files to exclude from unity groupings
    foreach(f ${SKIP_UNITY_BUILD_INCLUSION_FILES})
        get_filename_component(absolute_path ${f} ABSOLUTE)
        if(NOT EXISTS ${absolute_path})
            message(FATAL_ERROR "File ${absolute_path} for SKIP_UNITY_BUILD_INCLUSION_FILES referenced in ${file} not found")
        endif()
        if(NOT f IN_LIST FILES)
            list(APPEND FILES ${f})
        endif()
    endforeach()
    
    # Mark files tagged for unity build group exclusions for unity builds
    if (LY_UNITY_BUILD)
        set_source_files_properties(
            ${UNITY_AUTO_EXCLUSIONS}
            ${SKIP_UNITY_BUILD_INCLUSION_FILES}
            PROPERTIES 
                SKIP_UNITY_BUILD_INCLUSION ON
        )
    endif()
    
    set(ALLFILES ${ALLFILES} ${FILES} PARENT_SCOPE)

endfunction()

function(age_add_target)
    
    set(options STATIC SHARED MODULE HEADERONLY EXECUTABLE)
    set(oneValueArgs NAME NAMESPACE OUTPUT_SUBDIRECTORY OUTPUT_NAME)
    set(multiValueArgs FILES_CMAKE GENERATED_FILES INCLUDE_DIRECTORIES COMPILE_DEFINITIONS BUILD_DEPENDENCIES RUNTIME_DEPENDENCIES PLATFORM_INCLUDE_FILES TARGET_PROPERTIES)
    
    cmake_parse_arguments(age_add_target "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    if(NOT age_add_target_FILES_CMAKE) 
        message(FATAL_ERROR "You must provide a list of _files.cmake files for the target") 
    endif() 
    
    foreach(file_cmake ${age_add_target_FILES_CMAKE})
        age_include_cmake_file_list(${file_cmake})
    endforeach()
    
    foreach(f ${ALLFILES})
        message(${f})
    endforeach()
    
    if(age_add_target_EXECUTABLE)
        add_executable(${age_add_target_NAME} ${ALLFILES})
    elseif(age_add_target_HEADERONLY)
        add_custom_target(${age_add_target_NAME})
    elseif(age_add_target_STATIC)
        add_library(${age_add_target_NAME} STATIC ${ALLFILES})
    elseif(age_add_target_SHARED)
        add_library(${age_add_target_NAME} SHARED ${ALLFILES})
    elseif(age_add_target_MODULE)
        add_library(${age_add_target_NAME} MODULE ${ALLFILES})
    else()
        message(FATAL_ERROR "Target type is must be specified")
    endif()
    
    if(age_add_target_INCLUDE_DIRECTORIES)
        target_include_directories(${age_add_target_NAME} ${age_add_target_INCLUDE_DIRECTORIES})
    endif()
    
    if(age_add_target_BUILD_DEPENDENCIES)
        target_link_libraries(${age_add_target_NAME} ${age_add_target_BUILD_DEPENDENCIES})
    endif()
    
    if(age_add_target_COMPILE_DEFINITIONS) 
        target_compile_definitions(${age_add_target_NAME} ${age_add_target_COMPILE_DEFINITIONS} ) 
    endif() 

endfunction(age_add_target)

