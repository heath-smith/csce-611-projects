transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+/home/heathsmith/repos/csce-611-projects/lab_hex {/home/heathsmith/repos/csce-611-projects/lab_hex/top.sv}
vlog -sv -work work +incdir+/home/heathsmith/repos/csce-611-projects/lab_hex {/home/heathsmith/repos/csce-611-projects/lab_hex/hexdriver.sv}

