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

### 1. Define the vectors

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

### 2. Cross product definition

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

## 3. Expand the determinant

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

### 4. Final result

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

## 5. Physical interpretation

- **Roll moment** depends on lateral offset $(y_i)$
- **Pitch moment** depends on longitudinal offset $(x_i)$
- **Yaw moment** does not come from thrust geometry, only from motor reaction torque

---

## 6. Key takeaway

This result comes directly from the vector cross product:

$$
\boldsymbol{\tau} = \mathbf{r} \times \mathbf{F}
$$

and applies to any multirotor configuration.

