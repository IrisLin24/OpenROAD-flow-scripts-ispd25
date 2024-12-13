# OpenRoad Fix Setup & Hold Violation Workflow

## 0 Before Fixing: Repair Design

1. Insert Buffer
2. Resize instances

## 1 Get Endpoint in dbSta

``const VertexSet* endpoints = sta_->endpoints();``

1. Get slack of the endpoint
2. Check if ``end_slack < setup_slack_margin``
3. Sort endpoints in slack ascending sequence
4. Check if vector violating_end is empty, then log number of violating endpoints RepairSetup.cc:156

## 2 Start incrementalParasitics  RepairSetup.cc:167

```cpp
void Resizer::incrementalParasiticsBegin()
{
  switch (parasitics_src_) {
    case ParasiticsSrc::placement:
      break;
    case ParasiticsSrc::global_routing:
      incr_groute_ = new IncrementalGRoute(global_router_, block_);
      // Don't print verbose messages for incremental routing
      global_router_->setVerbose(false);
      break;
    case ParasiticsSrc::none:
      break;
  }
  parasitics_invalid_.clear();
}
```

## 3 Iterate all violating endpoints

### 0 Get worst slack endpoint &&

### 1 if (end_slack > setup_slack_margin)

1. use resizer to insert/remove buffer, gate cloning
2. update parasitics

### 2 repairPath

0. get variable changed

```cpp
const bool changed = repairPath(end_path,
                                      end_slack,
                                      skip_pin_swap,
                                      skip_gate_cloning,
                                      skip_buffering,
                                      skip_buffer_removal,
                                      setup_slack_margin);
```

0. ``if (!changed)``
   Restore best slack end slack & worst slack
1. updateParasitics
   1. updateRoutes(using fastrouteCore)
   2. estimateRC
2. get worst slack gain and judge if better

```cpp
const bool better
          = (fuzzyGreater(worst_slack, prev_worst_slack)
             || (end_index != 1 && fuzzyEqual(worst_slack, prev_worst_slack)
                 && fuzzyGreater(end_slack, prev_end_slack)));
```

    1.``if (better)``

```cpp
if (end_slack > setup_slack_margin) {
  --num_viols;
}
```

    2.``else`` (not better)
        restore journal
        update parasitics

## 4 Do some last gasp setup fixing before give up

Same as regular fixing workflow

## 5 End incrementalParasitics RepairSetupo.cc:

delete groutecore


disable buffering && sizing
remove all violating routes && reroute
