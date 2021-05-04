- Givan below a thin plate.     
- Temperature at its center is kept at 800 K.    
- The whole plate surface is initialized at 270 K.   
- No advection occurs on the plate, only diffusion.  
- The boundaries are thermally insulated (Neumann).  

![](https://github.com/auralius/numerical-methods-with-matlab/blob/main/transient_advection_diffusion/images/diffusion_only.gif)

-------------------------

- Given a thin plate where no diffusion occurs in it. 
- The plate only has advection which occurs diagonally.  
- At the bottom-left, the temperature is kept at 800k.
- The whole plate surface is initialized at 270 K.  
- The boundaries are Dirichlet, constrained at 270K.  

![](https://github.com/auralius/numerical-methods-with-matlab/blob/main/transient_advection_diffusion/images/advection_only.gif)

-------------------------

- We first define a circular vector field on a surface of a plate.  
- This vector field acts as advection vectors (u and v).  
- Both diffusion and advection take place.  

![](https://github.com/auralius/numerical-methods-with-matlab/blob/main/transient_advection_diffusion/images/circular_vector_field.gif)

-------------------------

- Based on: https://www.comsol.com/model/out-of-plane-heat-transfer-for-a-thin-plate-493  
- Given a thin copper plate, where the whole plate surface is initialized at 297.15 K.  
- The boundaries are Neumann with an exception on the left side wall. It is Dirichlet, constrained at 800K.  

![](https://github.com/auralius/numerical-methods-with-matlab/blob/main/transient_advection_diffusion/images/thinplate_diffusion_only.gif)

-------------------------
- Given below A counter-flow heat exchanger.  
- The temperature of  the cold source is 280K.  
- The temperature of  the hot source is 360K.

![](https://github.com/auralius/numerical-methods-with-matlab/blob/main/transient_advection_diffusion/images/heat_exchanger.gif)

