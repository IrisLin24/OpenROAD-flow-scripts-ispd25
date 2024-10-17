# STA Calls in OpenRoad flow

## Floorplan

floorplan.tcl:106

```tcl
if { [env_var_equals REMOVE_ABC_BUFFERS 1] } {
  # remove buffers inserted by yosys/abc
  remove_buffers
} else {
  repair_timing_helper 0
}
```

In repair timing, Openroad check timing violations using resizer, then resizer

## Placement

### Global Place

global_place.tcl:42

```tcl
estimate_parasitics -placement
```

global_place.tcl:44

```tcl
if {[env_var_equals CLUSTER_FLOPS 1]} {
  cluster_flops
  estimate_parasitics -placement
}
```

src/gpl/src/nesterovPlace.cpp:434-----Uses ``vertexSlack``

```cpp
bool shouldTdProceed = tb_->updateGNetWeights(average_overflow_);
```

Calls resize.tcl:34

```tcl
repair_design {*}$additional_args
```

report metrics in GPL uses report_tns that calls ``vertexSlack()``

### Detailed Place

report metrics in DPL uses report_tns that calls ``vertexSlack()``

## CTS

cts.tcl:71
repair_timing_helper calls repair_timing

## GRT

repair setup and hold violations
repair antennas

## Finish

report metrics

## Conclusion

To conclude, repair timing calls STA components to get all slacks
Repair design
EstimateRC uses corner informations in dbSTA

## At last

```tcl
proc repair_design { args } {
  sta::parse_key_args "repair_design" args \
    keys {-max_wire_length -max_utilization -slew_margin -cap_margin -buffer_gain} \
    flags {-verbose}

  set max_wire_length [rsz::parse_max_wire_length keys]
  set slew_margin [rsz::parse_percent_margin_arg "-slew_margin" keys]
  set cap_margin [rsz::parse_percent_margin_arg "-cap_margin" keys]
  set buffer_gain 0.0
  if { [info exists keys(-buffer_gain)] } {
    set buffer_gain $keys(-buffer_gain)
    sta::check_positive_float "-buffer_gain" $buffer_gain
  }
  rsz::set_max_utilization [rsz::parse_max_util keys]

  sta::check_argc_eq0 "repair_design" $args
  rsz::check_parasitics
  set max_wire_length [rsz::check_max_wire_length $max_wire_length]
  set verbose [info exists flags(-verbose)]
  rsz::repair_design_cmd $max_wire_length $slew_margin $cap_margin $buffer_gain $verbose
}
```

```tcl
proc repair_timing { args } {
  sta::parse_key_args "repair_timing" args \
    keys {-setup_margin -hold_margin -slack_margin \
            -libraries -max_utilization -max_buffer_percent \
            -recover_power -repair_tns -max_passes} \
    flags {-setup -hold -allow_setup_violations -skip_pin_swap -skip_gate_cloning \
           -skip_buffering -skip_buffer_removal -verbose}

  set setup [info exists flags(-setup)]
  set hold [info exists flags(-hold)]

  if { !$setup && !$hold } {
    set setup 1
    set hold 1
  }

  if { [info exists keys(-slack_margin)] } {
    utl::warn RSZ 76 "-slack_margin is deprecated. Use -setup_margin/-hold_margin"
    if { !$setup && $hold } {
      set setup_margin 0.0
      set hold_margin [rsz::parse_time_margin_arg "-slack_margin" keys]
    } else {
      set setup_margin [rsz::parse_time_margin_arg "-slack_margin" keys]
      set hold_margin 0.0
    }
  } else {
    set setup_margin [rsz::parse_time_margin_arg "-setup_margin" keys]
    set hold_margin [rsz::parse_time_margin_arg "-hold_margin" keys]
  }

  set allow_setup_violations [info exists flags(-allow_setup_violations)]
  set skip_pin_swap [info exists flags(-skip_pin_swap)]
  set skip_gate_cloning [info exists flags(-skip_gate_cloning)]
  set skip_buffering [info exists flags(-skip_buffering)]
  set skip_buffer_removal [info exists flags(-skip_buffer_removal)]
  rsz::set_max_utilization [rsz::parse_max_util keys]

  set max_buffer_percent 20
  if { [info exists keys(-max_buffer_percent)] } {
    set max_buffer_percent $keys(-max_buffer_percent)
    sta::check_percent "-max_buffer_percent" $max_buffer_percent
  }
  set max_buffer_percent [expr $max_buffer_percent / 100.0]

  set repair_tns_end_percent 1.0
  if { [info exists keys(-repair_tns)] } {
    set repair_tns_end_percent $keys(-repair_tns)
    sta::check_percent "-repair_tns" $repair_tns_end_percent
    set repair_tns_end_percent [expr $repair_tns_end_percent / 100.0]
  }

  set recover_power_percent -1
  if { [info exists keys(-recover_power)] } {
    set recover_power_percent $keys(-recover_power)
    sta::check_percent "-recover_power" $recover_power_percent
    set recover_power_percent [expr $recover_power_percent / 100.0]
  }

  set verbose 0
  if { [info exists flags(-verbose)] } {
    set verbose 1
  }

  set max_passes 10000
  if { [info exists keys(-max_passes)] } {
    set max_passes $keys(-max_passes)
  }
  sta::check_argc_eq0 "repair_timing" $args
  rsz::check_parasitics
  if { $recover_power_percent >= 0 } {
    rsz::recover_power $recover_power_percent
  } else {
    if { $setup } {
      rsz::repair_setup $setup_margin $repair_tns_end_percent $max_passes \
        $verbose \
        $skip_pin_swap $skip_gate_cloning $skip_buffering $skip_buffer_removal
    }
    if { $hold } {
      rsz::repair_hold $setup_margin $hold_margin \
        $allow_setup_violations $max_buffer_percent $max_passes \
        $verbose
    }
  }
}
```

# Oct 11
## 1. where to update timing && where to store ->vertexSlack()
update timing:
Search.cc: bookmarks
vertexSlack: find in the table

## 2. (50%) repair timing && save runtime
tools/OpenROAD/src/rsz/src/Resizer.tcl:570
repair timing settings

## 3. while loop
tools/OpenROAD/src/rsz/src/RepairSetup.cc:214/1687
1. At every 1k iterations, fix_rate *2 
2. At every 1k iterations, calc fix_rate. When fix_rate < threshold, terminate fixing.
When terminateProgress() returns true, a flag is set to 1. 
--This flag is used to determine whether the 

## 4. update timing? in report_metrics
tools/OpenROAD/src/sta/search/Search.tcl::693
tools/OpenROAD/src/sta/search/Search.i::232