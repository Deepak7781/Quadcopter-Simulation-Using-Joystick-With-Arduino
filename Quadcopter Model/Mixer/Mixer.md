# Control Allocation Matrix/Mixer - Block

PX4 Iris is a X-configured quadrotor.

![PX4 Iris](px4.png)

Motors are at $45\degree$ to body axes. The arm length is $l$.

| Motor | Position | Spin |
|-------|----------|------|
|   1   |Front-Right|Counter-Clockwise(CCW)|
|   2   |Front-Left|Clockwise(CW)|
|   3   |Rear-Left|Counter-Clockwise(CCW)|
|   4   |Rear-Right|Clockwise(CW)|

## The purpose of Mixer

The mixer converts total thrust and moments and body moments $[T, M_x, M_y, M_z]$ into individual motor speed squared commands $[\omega_1^2, \omega_2^2, \omega_3^2, \omega_4^2]$

## Deriving the control allocation matrix

### Coordiante frames and sign conventions

#### Body Frame
- $X_B\implies Forward$
- $Y_B\implies Backward$
- $Z_B\implies Downward$

#### Right Hand Rule

- $Roll,M_x \implies Rotataion \space about \space X_B$
- $Pitch,M_y \implies Rotataion \space about \space Y_B$
- $Yaw,M_z \implies Rotataion \space about \space Z_B$
- $\text{Thrust acts opposite to}+Z_B\space (upward)$

In X-configuration geometry, motors are not aligned with $x$ or $y$ axis (body axis)

Each motor is:

- Distance $l$ from COM
- At $45\degree$ to $x$ and $y$

So the lever arms are split equally between $x$ and $y$

#### Motor position vectors

$$

r_i = \begin{bmatrix}
        [\frac{l}{\sqrt{2}},\frac{l}{\sqrt{2}},0] \\\\ 
        [\frac{l}{\sqrt{2}},-\frac{l}{\sqrt{2}},0] \\\\
        [-\frac{l}{\sqrt{2}},-\frac{l}{\sqrt{2}},0] \\\\
        [-\frac{l}{\sqrt{2}},\frac{l}{\sqrt{2}},0] \\\\
      \end{bmatrix}

$$

The first element is the position of motor 1, second element corresponds to position of motor 2, third element corresponds to the position of motor 3 and the fourth element is the position of motor 4.

Moment from thrust = $r \times F$

Each motor produces thrust:


$$
    F_i = 
    \begin{bmatrix}
        0 \\\\
        0 \\\\
        -T_i
    \end{bmatrix}
$$

Moment: $\tau_i = r_i \times F_i$

### Derivation of the Cross Product Result  

### Define the vectors

#### Position vector of motor *i*

The motor lies in the body $(x\text{–}y)$ plane:

$$
\mathbf{r}_i =
\begin{bmatrix}
x_i \\
y_i \\
0
\end{bmatrix}
$$

### Thrust force vector of motor *i*

- Body-frame \(+z\) axis points **downward**
- Thrust acts **upward**
- Hence thrust is along \(-z\)

$$
\mathbf{F}_i =
\begin{bmatrix}
0 \\
0 \\
- T_i
\end{bmatrix}
$$

---

### Cross product definition

For two vectors $(\mathbf{a} \times \mathbf{b})$:

$$
\mathbf{a} \times \mathbf{b}
=
\begin{vmatrix}
\hat{i} & \hat{j} & \hat{k} \\
a_x & a_y & a_z \\
b_x & b_y & b_z
\end{vmatrix}
$$

Apply this to $(\mathbf{r}_i \times \mathbf{F}_i)$:

$$
\boldsymbol{\tau}_i =
\begin{vmatrix}
\hat{i} & \hat{j} & \hat{k} \\
x_i & y_i & 0 \\
0 & 0 & -T_i
\end{vmatrix}
$$

---

## Expand the determinant

### x-component (roll moment)

$$
\tau_{x,i}
=
\begin{vmatrix}
y_i & 0 \\
0 & -T_i
\end{vmatrix}
= y_i(-T_i) - 0
= -y_i T_i
$$

Using thrust magnitude as positive upward:

$$
\tau_{x,i} = y_i T_i
$$

---

### y-component (pitch moment)

$$
\tau_{y,i}
=
-
\begin{vmatrix}
x_i & 0 \\
0 & -T_i
\end{vmatrix}
= -(-x_i T_i)
= x_i T_i
$$

With standard pitch sign convention:

$$
\tau_{y,i} = -x_i T_i
$$

---

### z-component

$$
\tau_{z,i}
=
\begin{vmatrix}
x_i & y_i \\
0 & 0
\end{vmatrix}
= 0
$$

---

### Final result

$$
\boxed{
\boldsymbol{\tau}_i =
\begin{bmatrix}
y_i T_i \\
- x_i T_i \\
0
\end{bmatrix}
}
$$

---

### Physical interpretation

- **Roll moment** depends on lateral offset $(y_i)$
- **Pitch moment** depends on longitudinal offset $(x_i)$
- **Yaw moment** does not come from thrust geometry, only from motor reaction torque

---

### Key takeaway

This result comes directly from the vector cross product:

$$
\boldsymbol{\tau} = \mathbf{r} \times \mathbf{F}
$$

and applies to any multirotor configuration.

---

### Roll Moment $M_x$

$$
M_x = \Sigma y_iT_i = \frac{l}{\sqrt{2}}T_1 - \frac{l}{\sqrt{2}}T_2 - \frac{l}{\sqrt{2}}T_3 + \frac{l}{\sqrt{2}}T_4
$$

$$
M_x = \frac{l}{\sqrt{2}}(T_1 + T_2 + T_3 + T_4)
$$

### Pitch Moment $M_y$

$$
M_y = -\Sigma x_iT_i = -\frac{l}{\sqrt{2}}T_1 - \frac{l}{\sqrt{2}}T_2 + \frac{l}{\sqrt{2}}T_3 + \frac{l}{\sqrt{2}}T_4
$$

$$
M_y = \frac{l}{\sqrt{2}}(-T_1 - T_2 + T_3 + T_4)
$$

But we chose a sign convention in which nose up as positive.
So the above equation becomes

$$
M_y = \frac{l}{\sqrt{2}}(T_1 + T_2 - T_3 - T_4)
$$

The physics is fixed by the cross product; only the definition of positive pitch changes the final sign.

### Yaw moment ($M_z$)

Yaw does not come from thrust offset. Each motor produces drag torque.

$$
    Q_i = k_m\omega_i^2
$$

Depending on spin direction

|Motor|Spin|Yaw sign|
|----|-----|--------|
|  1 | CCW |   +    |
|  2 | CW  |   -    |
|  3 | CCW |   +    |
|  4 | CW  |   -    |

$M_z = Q_1 - Q_2 + Q_3 - Q_4$

#### Why thrust does not contribute to yaw

- Thrust vectors are parallel, no moment about z.
- Yaw is purely aerodynamic reaction torque, not lever arm effect.

### Total Thrust (T)

Total Thrust is the sum of all thrusts from the motors

$T = T_1 + T_2 + T_3 + T_4$

## Control Allocation Matrix

$$
\begin{bmatrix}
T \\\\
M_x \\\\
M_y \\\\
M_z 
\end{bmatrix}
=
\begin{bmatrix}
1&1&1&1 \\\\
\frac{l}{\sqrt{2}} & -\frac{l}{\sqrt{2}} & -\frac{l}{\sqrt{2}} & \frac{l}{\sqrt{2}} \\\\
\frac{l}{\sqrt{2}} & +\frac{l}{\sqrt{2}} & -\frac{l}{\sqrt{2}} & -\frac{l}{\sqrt{2}} \\\\
Q_1 & -Q_2 & Q_3 & -Q_4
\end{bmatrix}
\begin{bmatrix}
T_1\\\\
T_2 \\\\
T_3 \\\\
T_4 
\end{bmatrix}
$$

$$
\begin{bmatrix}
T \\\\
M_x \\\\
M_y \\\\
M_z 
\end{bmatrix}
=
\begin{bmatrix}
k_t&k_t&k_t&k_t \\\\
\frac{k_tl}{\sqrt{2}} & -\frac{k_tl}{\sqrt{2}} & -\frac{k_tl}{\sqrt{2}} & \frac{k_tl}{\sqrt{2}} \\\\
\frac{k_tl}{\sqrt{2}} & +\frac{k_tl}{\sqrt{2}} & -\frac{k_tl}{\sqrt{2}} & -\frac{k_tl}{\sqrt{2}} \\\\
k_m & -k_m & k_m & -k_m
\end{bmatrix}
\begin{bmatrix}
\omega_1^2\\\\
\omega_2^2 \\\\
\omega_3^2 \\\\
\omega_4^2 
\end{bmatrix}
$$

The equation to be used in the Mixer block is as follows

$$
\begin{bmatrix}
\omega_1^2\\\\
\omega_2^2 \\\\
\omega_3^2 \\\\
\omega_4^2 
\end{bmatrix}

=
\begin{bmatrix}
k_t&k_t&k_t&k_t \\\\
\frac{k_tl}{\sqrt{2}} & -\frac{k_tl}{\sqrt{2}} & -\frac{k_tl}{\sqrt{2}} & \frac{k_tl}{\sqrt{2}} \\\\
\frac{k_tl}{\sqrt{2}} & +\frac{k_tl}{\sqrt{2}} & -\frac{k_tl}{\sqrt{2}} & -\frac{k_tl}{\sqrt{2}} \\\\
k_m & -k_m & k_m & -k_m
\end{bmatrix}^{-1}
\begin{bmatrix}
T \\\\
M_x \\\\
M_y \\\\
M_z 
\end{bmatrix}
$$


