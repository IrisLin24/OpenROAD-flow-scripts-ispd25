# Global Routing Workflow

## 1. routeL

For all nets, with L-shape
n1, n2
treeedge->routetype = Lshape
route.xfirst.true   ==false
(0,0)->(1,1)
(0,0)-(1,0)-(1,1)

## 2. spiral Route

Still L-shape, but with rip-up and re-reoute.

## 3. routeZ

```cpp
newRouteZ(int netid, int threshold)
```

threshold = 10, only route nets with its length(manhattan distance) > 10
Find the best turning point, for ``treeedge->route.HVH == true``, find the x location for the turning point. For ``treeedge->route.HVH == flase``, find the y location for the turning point.

## 4.0. convertToMazeRoute

All nets will be converted into MaceRoute in this phase.

```cpp
convertToMazeroute();
```

In this phase, function `convertToMazerouteNet()` will check the `treeedge->route.type` attribute. Then, traverse all the Nets, update the Gcells that the net has gone through, update `treeedge->route.gridsX/Y` simultanenously.

## 4. monotonicRoute

3 Iterations, set with variable ``LVIter(Fastroute.cpp)``, which is ``3``(set in the original code)
Only route nets when its length > threshold
Iter1: ``threshold = 10(set in the original code)``
Iter2: ``threshold = 5(threshold -= 5)``
Iter3: ``threshold = 1``
In each iter:

1. Edge length check
2. Rip-up check
3. Calculate new bounding box (with parameter enlarge)
4. Update Costs
5. Traverse the bounding box to find a new route

## 5. 2D mazeRoute

at FastRoute.cpp:line 1160
max iteration = 500
total_overflow_>0&&i<=overflow_iterations_&&overflow_increases<=max_overflow_increases(25)

```cpp
mazeRouteMSMD(  i,  ...iteration
                enlarge_,  ...bounding box enlarge
                costheight_,  
                ripup_threshold,  ...ripup judged by overflow
                mazeedge_threshold_,
                !(i % 3),
                cost_type,
                LOGIS_COF,
                VIA,
                slope,
                L,
                slack_th);
```

extra circumstances(for hard benchmark, Log Code: GRT-103):

1. maxOverflow < 150 && i == 20 && past_cong > 200
2. 

## 6. Layer Assignment

## 7. 3D mazeRoute

when goingLV && past_cong == 0


1. Fix Setup Workflow
2. Shared data
