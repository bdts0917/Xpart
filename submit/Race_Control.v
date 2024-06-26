module Race_Control(
    input if_stall,
    input mem_stall,
    input switch_mode,
    input isJ,
    input br_taken,
    input EXnpc_sel,
    output PCstall,
    output IFIDstall,
    output IFIDflush,
    output IDEXstall,
    output IDEXflush,
    output EXMEMstall,
    output EXMEMflush,
    output MEMWBstall,
    output MEMWBflush
);

    wire data_race = 0;
    wire predict_jump = EXnpc_sel & (br_taken || isJ) | switch_mode;
     
    assign PCstall = (if_stall | mem_stall)& ~switch_mode;
    assign IFIDstall = mem_stall | data_race;
    assign IFIDflush = ~IFIDstall & (predict_jump|if_stall) | switch_mode;
    assign IDEXstall = predict_jump & if_stall | mem_stall | data_race;
    assign IDEXflush = ~IDEXstall & predict_jump | switch_mode;

    assign EXMEMstall = mem_stall;
    assign EXMEMflush = ~(EXMEMstall) & (data_race | predict_jump & if_stall) | switch_mode;

    assign MEMWBstall = 0;
    assign MEMWBflush = mem_stall | switch_mode;

endmodule   