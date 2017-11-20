cmake_minimum_required(VERSION 3.5)
project(sipcmd)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra -Werror")

include_directories(/usr/include/opal)

set(SOURCE_FILES
        src/channels.cpp
        src/commands.cpp
        src/main.cpp
)

add_executable(sipcmd ${SOURCE_FILES})

target_link_libraries(sipcmd -lopal -lpt)
install(TARGETS sipcmd DESTINATION bin)
