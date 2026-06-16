from setuptools import find_packages, setup

package_name = 'motor_controller'

setup(
    name=package_name,
    version='0.0.0',
    packages=find_packages(exclude=['test']),
    data_files=[
        ('share/ament_index/resource_index/packages',
            ['resource/' + package_name]),
        ('share/' + package_name, ['package.xml']),
    ],
    install_requires=['setuptools', 'gpiozero'],
    zip_safe=True,
    maintainer='Mo Akinbayo',
    maintainer_email='m.m.akinbayo@gmail.com',
    description='motor control for the Wabbit bot',
    license='MIT',
    extras_require={
        'test': [
            'pytest',
        ],
    },
    entry_points={
        'console_scripts': [
            'motor_driver = motor_controller.motor_driver:main'
        ],
    },
)
