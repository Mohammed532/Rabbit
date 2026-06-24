import rclpy
from rclpy.node import Node
from std_msgs.msg import Int32
from geometry_msgs.msg import Twist
from pynput import Keyboard


class KeyboardNode(Node):
    """node for reading keyboard inputs and publishing to /bot_vel and /servo_angle

    Topics (Publisher):
        /servo_angle - std_msgs/msg/Int32
        /bot_vel - geometry_msgs/msg/Twist
    """
    def __init__(self):
        super().__init__('keyboard')
        self.vel_pub = self.create_publisher(Twist, '/bot_vel', 10)
        self.angle_pub = self.create_publisher(Int32, '/servo_angle', 10)
        self.get_logger().info('Listening to keyboard...')
        
        # start non-blocking keyboard listener
        self.listener = keyboard.Listener(
                on_press = self.on_press
                on_release = self.on_release
                )
        self.listener.start()

    
    def on_press(self, key):
        ## Note to self: DONT put long running processes in callbacks
        pass

    def on_release(self, key):
        ## Note to self: DONT put long running processes in callbacks
        pass
        
def main():
    rclpy.init()

if __name__ == '__main__':
    main()
