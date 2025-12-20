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
