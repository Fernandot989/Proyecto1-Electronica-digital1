module Ordenar(input siguiente, regresar, cancelar, clk, reset, output reg Y0, Y1); //De las variables a utilizar se clasifican entre inputs y outputs
    reg [2:0] state, next_state; //Se establecen los estados con 3 bits
    parameter Menu = 3'b000, Comida = 3'b001, Bebida = 3'b010, Pago = 3'b011, Ordenconfirmada = 3'b100; //Se establecen los 5 estados con 3 bits
    
    // Nube combinacional para calcular el estado futuro y salidas

    always @ (siguiente or regresar or cancelar or state) begin 
        case (state)
            Menu: begin							//En Menu solo se establece: si siguiente es presionado pasa al estado Comida,
                    if (siguiente == 1)			//si no, se queda en Menu
                        next_state <= Comida;
					else
						next_state <= Menu;
                end
            Comida: begin						//En Comida se establece: si siguiente es presionada pasa al estado Bebida
                    if (siguiente == 1) 		//si es presionado regresar pasa al estado Menu
                        next_state <= Bebida; 	//si no se presiona ninguno de los dos se queda en el estado Comida
                    else if (regresar == 1)
                        next_state <= Menu;
					else
						next_state <= Comida;
                end
            Bebida: begin						//En Bebida se establece: si siguiente es presionado pasa al estado Pago
                    if (siguiente == 1) 		//si es presionado regresar pasa al estado Comida
                        next_state <= Pago; 	//si es presionado cancelar pasa al estado Menu
                    else if (regresar == 1)		////si no se presiona ninguno de los tres se queda en el estado Bebida
                        next_state <= Comida;
					else if (cancelar == 1)
						next_state <= Menu;
					else
						next_state <= Bebida;
                end
			Pago: begin							//En Bebida se establece: si siguiente es presionado pasa al estado Orden confirmada
                    if (siguiente == 1) 		//si es presionado regresar pasa al estado Bebida
                        next_state <= Ordenconfirmada; 	//si es presionado cancelar pasa al estado Menu
                    else if (regresar == 1)		//si no se presiona ninguno de los tres se queda en el estado Pago
                        next_state <= Bebida;
					else if (cancelar == 1)
						next_state <= Menu;
					else
						next_state <= Pago;
                end
			Ordenconfirmada: begin				//En Bebida se establece: si cancelar es presionado para al estado Menu
                    if (cancelar == 1) 			//si no se presiona cancelar se queda en el estado Orden confirmada
                        next_state <= Menu; 
					else
						next_state <= Ordenconfirmada; 						
                end
            default: 							//el estado de origen es Menu
				next_state <= Menu; 
        endcase
    end

    // Banco de flip flops
    always @ (posedge clk or posedge reset) begin	//Por cada flanco positivo de reloj se activa la acción deseada

        if (reset == 1)
            state <= Menu;
        else
            state <= next_state;
    end
	initial state <= 3'b000;
	
    // Nube combinacional para calcular las salidas
	 always @ (state) begin							
        case (state)
            Menu: begin 		//En el estado Menu Y0 se ilumina y Y1 se apaga
				Y0 <= 1'b1;
				Y1 <= 1'b0;
				end
            Comida: begin 		//En el estado Comida tanto Y0 como Y1 estan apagados
				Y0 <= 1'b0;
				Y1 <= 1'b0;
				end
            Bebida: begin 		//En el estado Bebida tanto Y0 como Y1 estan apagados
				Y0 <= 1'b0;
				Y1 <= 1'b0;
				end
			Pago: begin 		//En el estado Pago tanto Y0 como Y1 estan apagados
				Y0 <= 1'b0;
				Y1 <= 1'b0;
				end
			Ordenconfirmada: begin //En el estado Ordenconfirmada tanto Y0 como Y1 estan apagados
				Y0 <= 1'b0;
				Y1 <= 1'b1;
				end
            default: begin		//En su estado de origen Y0 y Y1 estan apagados
				Y0 <= 1'b0;
				Y1 <= 1'b0;
				end
        endcase
    end	
endmodule