from setuptools import find_packages, setup

package_name = 'servo_controller'

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
    description='Package for controlling on bot servo',
    license='MIT',
    extras_require={
        'test': [
            'pytest',
        ],
    },
    entry_points={
        'console_scripts': [
            'servo_driver = servo_controller.servo_driver:main',
        ],
    },
)
