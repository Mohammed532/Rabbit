from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription
from launch.launch_description_sources import AnyLaunchDescriptionSource
from launch_ros.actions import Node

from ament_index_python.packages import get_package_share_directory
import os

def generate_launch_description():
    return LaunchDescription([
        IncludeLaunchDescription(
            AnyLaunchDescriptionSource(
                os.path.join(
                    get_package_share_directory("rosbridge_server"),
                    "launch",
                    "rosbridge_websocket_launch.xml"
                    )
                )
            ),
        Node(
            package='motor_controller',
            namespace='motor_controller',
            executable='motor_driver',
            name='driver',
            ),
        Node(
            package='servo_controller',
            namespace='servo_controller',
            executable='servo_driver',
            name='servo'
            )
        ])

