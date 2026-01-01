# Extended Kalman Filter

## Why EKF?

- Kalman Filter (KF) assumes linear models. In real-world systems, dynamics and sensor models are often nonlinear.
- EKF extends KF to nonlinear systems via linearization.

### EKF application examples for drones:
- Sensor fusion (IMU + GPS) for state estimation.
- Estimating position, velocity, and orientation from IMU and GPS.
- Visual odometry
- External disturbaance (wind) disturbance
- Attitude and Altitude estimation
