import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
from gpiozero import Robot, Motor

#####################
# HARDWARE
####################
M_DRIVE = Robot(left=Motor(27, 22), right=Motor(23,24))

#####################
# CONSTANTS
####################
DEADZONE = 0.1          # deadzone value for motor control (or future app joystick implementation) 

class MotorDriver(Node):
    """motor_driver for control bot drive
    
    Topics (Subscriber):
        /bot_vel - geometry_msg/Twist 
    """
    def __init__(self):
        super().__init__('motor_driver')
        self.get_logger().info("Motor Driver Node Started...")
        self.subscription = self.create_subscription(Twist, '/bot_vel', self.callback, 10)

    def callback(self, msg):
        l_vel = msg.linear.x                    # linear velocity (forward back)
        a_vel = msg.angular.z                   # angular velocity (left right)

        left_speed = l_vel + a_vel
        right_speed = l_vel - a_vel

        # clamping
        left_speed = max(-1.0, min(1.0, left_speed))
        right_speed = max(-1.0, min(1.0, right_speed))

        # deadzoning
        if abs(left_speed) < DEADZONE:
            left_speed = 0.0
        if abs(right_speed) < DEADZONE:
            right_speed = 0.0

        M_DRIVE.value = (left_speed, right_speed)
        self.get_logger().info(f'Driving motors: left - {left_speed}, right - {right_speed}')

def main():
    rclpy.init()
    mdrive_node = MotorDriver()
    rclpy.spin(mdrive_node)
    mdrive_node.destroy_node()
    rclpy.shutdown()

if __name__ == '__main__':
    main()
