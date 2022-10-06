module top (
	input CLK,
		input PIN_4, PIN_14, PIN_17, PIN_20, PIN_23, //Se establecen los pines de entrada
		output PIN_7, PIN_8, PIN_9, PIN_10, PIN_11, PIN_12, PIN_13, //Se establecen los pines de salida
    output LED,   // User/boot LED next to power LED
    output USBPU  // USB pull-up resistor
);	
	// drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 1'b0;
	
    wire siguiente, regresar, cancelar, enable, Y0, Y1, Y2, Y3, S2, S3, S4, reset, clk; //Se declara todas las variables como cables
	assign siguiente = ~PIN_14; //Se establecen los pines de entrada a sus respectivas variables negados
	assign regresar = ~PIN_17;
	assign cancelar = ~PIN_23;
	assign enable = ~PIN_4;
	assign reset = 0; //Se establece el valor del reset como 0
	
	assign S2 = PIN_7; //Se establecen los pines de salida a sus respectivas variables
	assign S3 = PIN_8;
	assign S4 = PIN_9;
	assign Y0 = PIN_10;
	assign Y1 = PIN_11;
	assign Y2 = PIN_12;
	assign Y3 = PIN_13;
	
	assign clk = counter[25]; //Se le da un conter de 25 al clock
	
    Ordenar FMS1(siguiente, regresar, cancelar, clk, reset, Y0, Y1); //Se llama a las maquinas con las variables que necesita cada variable.
	Entregar FSM2(enable, siguiente, clk, reset, Y2, Y3);	
	
	// keep track of time and location in blink_pattern
    reg [25:0] counter;

    // increment the blink_counter every clock
    always @(posedge CLK) begin
        counter <= counter + 1;
    end
	//La led se enciende con el reloj
	assign LED = clk;
endmodule

