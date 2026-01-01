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

## What is EKF?

- Extended version of linear Kalman Filter.
- EKF handles nonlinear dynamic system models.
- Basic Idea:
    - Linearization: approximates nonlinear models using first-order Taylor series expansion.
    - Model linearized with Jacobians
    - Linearized models are used to apply standard Kalman Filter equations.
- Used when system is approximately linear in small neighbourhoods around the aroound estimate.
- Works well foe systems with moderate nonlinearities and gaussian noise.

## Key components of EKF:

- Nonlinear state equation:

$$
    \dot{x} = f(x,u)
$$

- Nonlinear Measurement function

$$
    z = h(x,u)
$$

- Linearization: Jacobian computation by Taylor series expansion.

- Jacobian of $f$ with respect to state:

$$
    F_k = \left.\frac{\partial f}{\partial x}\right|_{\hat{x}_{k-1},\,u_k}
$$

- Jacobian of $h$ with respect to state:

$$
    H_k = \left.\frac{\partial h}{\partial x}\right|_{\hat{x}_{k|k-1}}
$$

- Process and measurement noise covariances: $Q,R$ (important for good modelling and tuning)

## EKF Algorithm

### Prediction:

$$
    \hat{\mathbf{x}}_{k|k-1} = \boldsymbol{A}\hat{\mathbf{x}}_{k-1|k-1} + \boldsymbol{B}\mathbf{u}_{k-1}
$$

$$
    P_{k|k-1} = F_kP_{k-1}F_k^T + Q_k 
$$

where $F_k$ is the Jacobians

### Correction

$$
K_k = P_{k|k-1}H_k^T(H_kP_{k|k-1}H_k^T + R_k)^{-1}
$$

$$
    \hat{\mathbf{x}}_k = \hat{\mathbf{x}}_{k|k-1} + K_k(y_k - h(\hat{\mathbf{x}}_{k|k-1}))
$$

$$
    P_k = (I - K_kH_k)P_{k|k-1}
$$

