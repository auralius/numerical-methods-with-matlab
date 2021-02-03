What has been implemeted so far:
- Upwind method
- Downwind method
- Lax method
- Lax-Wendroff method

---------------------------------------------------

Upwind:

```
c = 0.5
u(x,0) = exp(-(x-2).^2)
```

![alt text](https://github.com/auralius/numerical-methods-with-matlab/blob/main/advection/images/upwind.gif)

Downwind:

```
c = -0.5
u(x,0) = exp(-(x-8).^2)
```

![alt text](https://github.com/auralius/numerical-methods-with-matlab/blob/main/advection/images/downwind.gif)

Cross current heat-exchanger:

![alt text](https://github.com/auralius/numerical-methods-with-matlab/blob/main/advection/images/heat_exchanger.gif)
