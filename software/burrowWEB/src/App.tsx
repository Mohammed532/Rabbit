/**
 * BURROWWEB
 * Testing app for Wabbit
 */

import { useState, useEffect, useRef } from 'react'
import { Joystick } from 'react-joystick-component';
import * as ROSLIB from 'roslib';

const ROS_SOCKET_URL = "ws://192.168.1.181:9090";
const ros = new ROSLIB.Ros({
  url: ROS_SOCKET_URL, // TODO: should connect in useeffect to handle error better, lazy rn
})

// ============ Topics ===============
const botVel = new ROSLIB.Topic({
  ros: ros,
  name: '/bot_vel',
  messageType: 'geometry_msgs/msg/Twist'
});

const servoAngle = new ROSLIB.Topic({
  ros: ros,
  name: '/servo_angle',
  messageType: 'std_msgs/msg/Int32'
})
//=====================================

const PUBLISH_HZ = 10; // publish frequency

function App() {
  const joystick = useRef({x: 0.0, y:0.0});
  const servAngle = useRef(0);
  const [connected, setConnectStatus] = useState(false);

  useEffect(() => {
    const publishInterval = setInterval(() => {
      botVel.publish({
        linear: {x: joystick.current.y},
        angular: {z: joystick.current.x}
      });

      servoAngle.publish({
        data: servAngle.current
      });
    }, 1000 / PUBLISH_HZ);

    
    return () => {
      ros.close();
      clearInterval(publishInterval);
    }
  }, [])

// ================= ROS Control ==========================

  ros.on('connection', () => {
    console.log('ROS Connected');
    setConnectStatus(true);
  });

  ros.on('close', () => {
    console.log('ROS Disconnected');
    setConnectStatus(false);
  })

  ros.on('error', (err: any) => {
    console.log('Error connecting to server', err);
  });

// ======================================================

  let handleJoyMove = (e: any) => {
    joystick.current = {x: e.x, y: e.y};
  }

  let handleJoyStop = () => {
    joystick.current = {x: 0.0, y: 0.0};
  }

  let handleServoSwitch = () => {
    let angle = servAngle.current === 0 ? 45 : 0;
    console.log(`Servo set to ${angle}deg`);
    servAngle.current = angle;
  }

  return (
    <div className='m-3'>
      <div className='header flex justify-between items-center'>
        <h1>BurrowWEB</h1>
        {connected ? <p className='connect text-green-500'>WABBIT Connected</p> : <p className='disconnect text-red-500'>WABBIT Disconected</p>}
      </div>
      <div className='flex flex-col h-[90vh] justify-center items-center gap-9'>
        <div className='flex flex-col justify-center gap-4'>
          <p>Joystick Control</p>
          <Joystick size={200} move={handleJoyMove} stop={handleJoyStop}/> 
        </div>
         <button className='border-2 rounded-sm w-1/3 p-4' onClick={handleServoSwitch}>Toggle Servo</button>
      </div>
    </div>
  )
}

export default App
