module top;

import uvm_pkg::*;

import test_pkg::*;

bit Hclk;

always 
#5 Hclk=~Hclk;

bus_if in0(Hclk);
bus_if in1(Hclk);


rtl_top DUV(.Hclk(in0.Hclk), .Hresetn(in0.Hresetn), .Htrans(in0.Htrans), .Hsize(in0.Hsize), .Hreadyin(in0.Hreadyin), .Hwdata(in0.Hwdata), .Haddr(in0.Haddr), .Hwrite(in0.Hwrite), .Prdata(in1.Prdata), .Hrdata(in0.Hrdata), .Hresp(in0.Hresp), .Hreadyout(in0.Hreadyout), .Pselx(in1.Pselx), .Pwrite(in1.Pwrite), .Penable(in1.Penable), .Paddr(in1.Paddr), .Pwdata(in1.Pwdata));

initial 
begin
`ifdef VCS
         		$fsdbDumpvars(0,top);
        		`endif

uvm_config_db #(virtual bus_if)::set(null,"*","in0",in0);
uvm_config_db #(virtual bus_if)::set(null,"*","in1",in1);

run_test();
end
endmodule


