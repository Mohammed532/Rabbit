import rclpy
from rclpy.node import Node
from std_msgs.msg import Int32
from gpiozero import AngularServo

##### HARDWARE
servo = AngularServo(5, min_angle=0, max_angle=90)

class ServoDriver(Node):
    def __init__(self):
        super().__init__('servo_driver')
        self.subscription = self.create_subscription(Int32, '/servo_angle', self.callback, 10)

    def callback(self, msg):
        if msg.data > 45:
            self.get_logger().warning("Input angle too large, defaulting to 45deg", once=True)
        angle = max(0, min(45, msg.data))      # ensures angle is between 0 and 45
        servo.angle = angle
        self.get_logger().info(f'Moving servo to {angle}deg', once=True)

def main():
    rclpy.init()
    servo_node = ServoDriver()
    rclpy.spin(servo_node)
    servo_node.destroy_node()
    rclpy.shutdown()

if __name__ == "__main__":
    main()
