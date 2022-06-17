`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.11.2021 13:22:53
// Design Name: 
// Module Name: vga_out
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module vga_out (
    input clk,
    //input sw[2:0],
    input BTNU,
    input BTND,
    input BTNL,
    input BTNR,
    input BTNC,
    output [3:0] pix_r,
    output [3:0] pix_g,
    output [3:0] pix_b,
    output hsync,
    output vsync,
    output [6:0] sg,
    output [7:0] an,
    output [15:0] LED
);

  // Declared as wires - assigned to in combinatorial statement
  wire [10:0] hcount;
  wire [9:0] vcount;
  wire in_drawing_region;

  // set up 7-seg display
  //reg [3:0] digits [7:0];
  //wire [3:0] digits [7:0];
  reg [31:0] score = 0;
  reg [15:0] led_reg = 16'h0000;
  assign LED = led_reg;

  seginterface seg (
      .clk(clk),
      .dig7(score[31:28]),
      .dig6(score[27:24]),
      .dig5(score[23:20]),
      .dig4(score[19:16]),
      .dig3(score[15:12]),
      .dig2(score[11:8]),
      .dig1(score[7:4]),
      .dig0(score[3:0]),
      .a(sg[0]),
      .b(sg[1]),
      .c(sg[2]),
      .d(sg[3]),
      .e(sg[4]),
      .f(sg[5]),
      .g(sg[6]),
      .an(an)
  );

  // set up vga timings
  vga_timing vga_timer (
      .clk(clk),
      .hsync(hsync),
      .vsync(vsync),
      .hcount_reg(hcount),
      .vcount_reg(vcount),
      .in_drawing_region(in_drawing_region)
  );

  reg width = 1440;
  reg height = 900;


  //reg [15551999:0] buffer;
  //reg [3:0] buffer [1295999:0];
  //reg [21:0] px_count;

  //reg [3:0] scale = 4;

  reg [6:0] squ_size_x = 49;
  reg [6:0] squ_size_y = 49;
  reg [10:0] squ_x = 200;
  reg [9:0] squ_y = 200;
  reg lr = 1;
  reg ud = 1;

  wire blk_en = 1;

  // setup banner image
  reg [17:0] banner_px_count = 0;
  wire [3:0] banner_out;
  banner_rom banner (
      .clka (clk),  // input wire clka
      .ena  (blk_en),  // input wire ena
      .addra(banner_px_count),  // input wire [17 : 0] addra
      .douta(banner_out)  // output wire [3 : 0] douta
  );
  wire in_banner_region;
  assign in_banner_region = ((hcount >= 384) && (hcount < 1824) && (vcount >= 31) && (vcount < 131)); // may need adjusting
  reg [11:0] banner_palette[0:15];

  // setup brick wall image
  reg [17:0] wall_px_count = 0;
  wire [3:0] wall_out;
  wall_rom wall (
      .clka (clk),  // input wire clka
      .ena  (blk_en),  // input wire ena
      .addra(wall_px_count),  // input wire [17 : 0] addra
      .douta(wall_out)  // output wire [3 : 0] douta
  );
  wire in_wall_region;
  assign in_wall_region = ((hcount >= 1624) && (hcount < 1824) && (vcount >= 131) && (vcount < 931));
  reg [11:0] wall_palette[0:15];

  // setup target image
  reg [14:0] target_px_count = 0;
  wire [3:0] target_out;
  target_rom target (
      .clka (clk),  // input wire clka
      .ena  (blk_en),  // input wire ena
      .addra(target_px_count),  // input wire [14 : 0] addra
      .douta(target_out)  // output wire [3 : 0] douta
  );
  wire in_target_region;
  assign in_target_region = ((hcount >= 1649) && (hcount < 1799) && (vcount >= 156) && (vcount < 306));
  reg [11:0] target_palette[0:15];

  // setup target image 2
  reg [14:0] target2_px_count = 0;
  wire [3:0] target2_out;
  target_rom target2 (
      .clka (clk),  // input wire clka
      .ena  (blk_en),  // input wire ena
      .addra(target2_px_count),  // input wire [14 : 0] addra
      .douta(target2_out)  // output wire [3 : 0] douta
  );
  wire in_target2_region;
  assign in_target2_region = ((hcount >= 1649) && (hcount < 1799) && (vcount >= 456) && (vcount < 606));

  // setup cannons
  reg  [15:0] cannon_px_count = 0;
  wire [ 3:0] cannon_30_out;
  wire [ 3:0] cannon_45_out;
  wire [ 3:0] cannon_60_out;
  cannon_30_rom cannon_30 (
      .clka (clk),  // input wire clka
      .ena  (blk_en),  // input wire ena
      .addra(cannon_px_count),  // input wire [15 : 0] addra
      .douta(cannon_30_out)  // output wire [3 : 0] douta
  );
  cannon_45_rom cannon_45 (
      .clka (clk),  // input wire clka
      .ena  (blk_en),  // input wire ena
      .addra(cannon_px_count),  // input wire [15 : 0] addra
      .douta(cannon_45_out)  // output wire [3 : 0] douta
  );
  cannon_60_rom cannon_60 (
      .clka (clk),  // input wire clka
      .ena  (blk_en),  // input wire ena
      .addra(cannon_px_count),  // input wire [15 : 0] addra
      .douta(cannon_60_out)  // output wire [3 : 0] douta
  );
  wire in_cannon_region;
  assign in_cannon_region = ((hcount >= 384) && (hcount < 584) && (vcount >= 731) && (vcount < 931));
  reg [11:0] cannon_palette[0:15];

  // setup cannonball
  reg [10:0] cannonball_x = 1;
  reg [9:0] cannonball_y = 859;
  reg [6:0] cannonball_size = 7'd40;
  reg [5:0] cannonball_xvel = 0;
  reg signed [6:0] cannonball_yvel = 0;  // essentially 0
  reg cannonball_shot = 0;
  reg [5:0] launch_pwr = 0;
  reg [5:0] accel_app_count = 0;

  reg [14:0] cannonball_px_count = 0;
  wire [3:0] cannonball_out;
  cannonball_rom cannonball (
      .clka (clk),  // input wire clka
      .ena  (blk_en),  // input wire ena
      .addra(cannonball_px_count),  // input wire [10 : 0] addra
      .douta(cannonball_out)  // output wire [3 : 0] douta
  );
  wire in_cannonball_region;
  assign in_cannonball_region = ((hcount >= (384 + cannonball_x)) && (hcount < (384 + cannonball_x + cannonball_size)) && (vcount >= (31 + cannonball_y)) && (vcount < (31 + cannonball_y + cannonball_size)));
  reg  [11:0] cannonball_palette[0:15];

  // setup power bar
  reg  [13:0] pwr_px_count = 0;
  wire [ 3:0] pwr_out;
  pwr_rom pwr (
      .clka (clk),  // input wire clka
      .ena  (blk_en),  // input wire ena
      .addra(pwr_px_count),  // input wire [13 : 0] addra
      .douta(pwr_out)  // output wire [3 : 0] douta
  );
  wire in_pwr_region;
  assign in_pwr_region = ((hcount >= 384) && (hcount < 634) && (vcount >= 181) && (vcount < 231));
  reg [11:0] pwr_palette[0:15];

  // setup timer bar frame
  reg [13:0] timerframe_px_count = 0;
  wire [3:0] timerframe_out;
  timerframe_rom timerframe (
      .clka (clk),  // input wire clka
      .ena  (blk_en),  // input wire ena
      .addra(timerframe_px_count),  // input wire [13 : 0] addra
      .douta(timerframe_out)  // output wire [3 : 0] douta
  );
  wire in_timerframe_region;
  assign in_timerframe_region = ((hcount >= 384) && (hcount < 634) && (vcount >= 131) && (vcount < 181));
  reg  [11:0] timerframe_palette [0:15];

  // setup timer bar fill
  reg  [13:0] timer_px_count = 0;
  wire [ 3:0] timer_out;
  timer_rom timer (
      .clka (clk),  // input wire clka
      .ena  (blk_en),  // input wire ena
      .addra(timer_px_count),  // input wire [13 : 0] addra
      .douta(timer_out)  // output wire [3 : 0] douta
  );
  wire in_timer_region;
  assign in_timer_region = ((hcount >= 394) && (hcount < 624) && (vcount >= 141) && (vcount < 171));
  reg [11:0] timer_palette[0:15];

  // setup start screen
  reg [15:0] start_px_count = 0;
  wire [3:0] start_out;
  start_rom startscr (
      .clka (clk),  // input wire clka
      .ena  (blk_en),  // input wire ena
      .addra(start_px_count),  // input wire [15 : 0] addra
      .douta(start_out)  // output wire [3 : 0] douta
  );
  wire in_start_region;
  assign in_start_region = ((hcount >= 939) && (hcount < 1269) && (vcount >= 425) && (vcount < 575));
  reg [11:0] start_palette[0:15];

  // setup end screen
  reg [15:0] end_px_count = 0;
  wire [3:0] end_out;
  end_rom endscr (
      .clka (clk),  // input wire clka
      .ena  (blk_en),  // input wire ena
      .addra(end_px_count),  // input wire [15 : 0] addra
      .douta(end_out)  // output wire [3 : 0] douta
  );
  wire in_end_region;
  assign in_end_region = ((hcount >= 939) && (hcount < 1269) && (vcount >= 402) && (vcount < 597));
  reg [11:0] end_palette[0:15];

  // setup target collision boxes
  wire in_target_coll; // covers target1 and 2: may need to seperate if you want different scores for each target
  assign in_target_coll = (((cannonball_x + cannonball_size) >= 1288) && (cannonball_x < 1392) && ( (((cannonball_y + cannonball_size) >= 148) && (cannonball_y < 252)) || (((cannonball_y + cannonball_size) >= 448) && (cannonball_y < 552))) );

  reg [7:0] game_time = 0;
  reg [4:0] time_inc = 0;

  // import sprite palettes
  initial begin
    $readmemh("img_palette.mem", palette);
    $readmemh("banner_palette.mem", banner_palette);
    $readmemh("wall_palette.mem", wall_palette);
    $readmemh("target_palette.mem", target_palette);
    $readmemh("cannon_palette.mem", cannon_palette);
    $readmemh("cannonball_palette.mem", cannonball_palette);
    $readmemh("pwr_palette.mem", pwr_palette);
    $readmemh("timerframe_palette.mem", timerframe_palette);
    $readmemh("timer_palette.mem", timer_palette);
    $readmemh("start_palette.mem", start_palette);
    $readmemh("end_palette.mem", end_palette);
  end


  always @(posedge clk) begin
    // on each pixel increment pixel counts for each image
    if (in_banner_region) begin
      banner_px_count <= banner_px_count + 1;
    end
    if (in_wall_region) begin
      wall_px_count <= wall_px_count + 1;
    end
    if (in_target_region) begin
      target_px_count <= target_px_count + 1;
    end
    if (in_target2_region) begin
      target2_px_count <= target2_px_count + 1;
    end
    if (in_cannon_region) begin
      cannon_px_count <= cannon_px_count + 1;
    end
    if (in_cannonball_region) begin
      cannonball_px_count <= cannonball_px_count + 1;
    end
    if (in_pwr_region) begin
      pwr_px_count <= pwr_px_count + 1;
    end
    if (in_timerframe_region) begin
      timerframe_px_count <= timerframe_px_count + 1;
    end
    if (in_timer_region) begin
      timer_px_count <= timer_px_count + 1;
    end
    if (in_start_region) begin
      start_px_count <= start_px_count + 1;
    end
    if (in_end_region) begin
      end_px_count <= end_px_count + 1;
    end


    // reset pixel counts at end of frame
    if (hcount == 11'd0 && vcount == 10'd0) begin
      banner_px_count <= 0;
      wall_px_count <= 0;
      target_px_count <= 0;
      target2_px_count <= 0;
      cannon_px_count <= 0;
      cannonball_px_count <= 0;
      pwr_px_count <= 0;
      timerframe_px_count <= 0;
      timer_px_count <= 0;
      start_px_count <= 0;
      end_px_count <= 0;
    end
  end


  reg [1:0] cannon_num = 0;

  reg last_btnr = 0;
  reg last_btnc = 0;

  reg [1:0] game_state = 0;
  // 0 = start screen
  // 1 = playing
  // 2 = game over

  reg left_start = 0;

  wire cannonball_yvel_neg;
  assign cannonball_yvel_neg = cannonball_yvel < 0;

  always @(posedge clk) begin

    if (game_state == 0) begin
      // start screen
      if (!BTNC && last_btnc) begin
        game_state <= 1;
      end
      last_btnc <= BTNC;

    end else if (game_state == 1) begin

      /* 
      ========================
      === GAME LOGIC BLOCK ===
      ======================== 
      */

      // change cannon number when btnr is pressed
      if (BTNR == 1'b1 && last_btnr == 1'b0) begin
        if (cannon_num != 2'd2) begin
          cannon_num <= cannon_num + 1;
        end else begin
          cannon_num <= 0;
        end
      end

      // between each frame (so we avoid tearing!!)
      if (hcount == 11'd0 && vcount == 10'd0) begin

        // set LEDs off when needed
        if (cannonball_shot) begin
          led_reg <= 16'h0000;
        end

        // increment game time
        time_inc <= time_inc + 1;
        if (time_inc == 0) begin
          game_time <= game_time + 1;
        end

        // end game is applicable
        if (game_time == 230) begin
          game_state <= 2;
        end

        if (accel_app_count == (6'd2 + launch_pwr[5:1])) begin  //maybe not 2
          // every the acceleration pause reaches 1/2 of launch power, reset the
          // count (and apply the acceleration)
          accel_app_count <= 0;
        end else begin
          accel_app_count <= accel_app_count + 1;
        end

        // Check if off screen, hasn't been shot, or on target and reset needed
        if (!cannonball_shot || cannonball_x > 1440 || in_target_coll) begin
          if (cannonball_x > 1440 || in_target_coll) begin
            // if off screen or on target, reset
            launch_pwr <= 0;

            // If target just hit, light up and increase score
            if (in_target_coll) begin
              led_reg <= 16'hFFFF;
              score   <= score + 1;

              // Correct score for display
              if (score[3:0] == 4'd9) begin
                score[3:0] <= 4'd0;
                score[7:4] <= score[7:4] + 4'd1;
                if (score[7:4] == 4'd9) begin
                  score[7:4]  <= 4'd0;
                  score[11:8] <= score[11:8] + 4'd1;
                  if (score[11:8] == 4'd9) begin
                    score[11:8]  <= 4'd0;
                    score[15:12] <= score[15:12] + 4'd1;
                    // impossible to score higher than this - no further correction
                  end
                end
              end
            end

          end else if (BTNC) begin
            // if BTNC is held, increase launch power until it overflows
            if (launch_pwr == 25) begin
              launch_pwr <= 1;
            end else begin
              launch_pwr <= launch_pwr + 1;
            end
          end

          // reset the cannonball
          cannonball_shot <= 0;
          cannonball_x <= 1;
          cannonball_y <= 859;
          cannonball_xvel <= 0;
          cannonball_yvel <= 0;

          // if canonnball has been shot and is on screen
          // change velocity and animate cannonball
        end else if (cannonball_shot) begin

          // Change x pos
          if (cannonball_xvel >= 32) begin
            // if cannonball x veloctiy is positive, add it to x
            cannonball_x <= cannonball_x + (cannonball_xvel - 32);
          end

          // handle bounds, swap velocity
          // if bouncing on top of screen
          if (cannonball_y < 101) begin
            cannonball_y <= 101;
            // invert velocity if positive
            if (!cannonball_yvel_neg) begin
              cannonball_yvel <= -(cannonball_yvel / 2);
            end

            // if bouncing on bottom of screen
          end else if (cannonball_y > (900 - cannonball_size)) begin
            cannonball_y = (900 - cannonball_size);
            // invert velocity if negative
            if (cannonball_yvel_neg) begin
              cannonball_yvel <= -(cannonball_yvel / 2);
            end

            // if not bouncing or at terminal velocity
          end else begin
            cannonball_y <= cannonball_y - cannonball_yvel;
          end
          //cannonball_y <= cannonball_y - (cannonball_yvel - 32); // MAYBE + not -? not sure


          // Gravity
          if (accel_app_count == 0 && cannonball_yvel > -10) begin
            cannonball_yvel <= cannonball_yvel - 1;

          end
        end


      end else if (!cannonball_shot && BTNC == 1'b0 && last_btnc == 1'b1) begin
        // BTNC let go
        // Stop shooting on first press of BTNC (leaving start screen)
        if (left_start) begin
          cannonball_shot <= 1;
          if (cannon_num == 2'd0) begin
            cannonball_xvel <= 39;
            cannonball_yvel <= 30;
          end else if (cannon_num == 2'd1) begin
            cannonball_xvel <= 42;
            cannonball_yvel <= 10;
          end else begin
            cannonball_xvel <= 44;
            cannonball_yvel <= 8;
          end
        end

      end else begin
        left_start <= 1;
      end


      last_btnr <= BTNR;
      last_btnc <= BTNC;

      // end screen logic
    end else if (game_state == 2) begin
      if (BTNL) begin
        game_state <= 0;
        game_time <= 0;
        score <= 32'h00000000;
      end else if (BTNR) begin
        game_state <= 1;
        game_time <= 0;
        left_start <= 0;
        score <= 32'h00000000;
      end
    end
  end



  reg [11:0] pix = 0;
  reg draw_en;

  always @(posedge clk) begin

    draw_en <= 0;

    if (game_state == 0) begin
      if (in_start_region) begin
        draw_en <= 1;
        pix <= start_palette[start_out];
      end
      if (in_banner_region) begin
        draw_en <= 1;
        pix <= banner_palette[banner_out];
      end

    end else if (game_state == 1) begin
      // game play

      // Drawing logic block
      // for each pixel in the frame, check if it is in a region and draw it

      //pix <= 12'h000; // black is default colour
      if (in_wall_region) begin
        draw_en <= 1;
        pix <= wall_palette[wall_out];
      end

      if (in_cannon_region) begin
        if (cannon_num == 2'd0 && cannon_palette[cannon_30_out] != 12'h001) begin
          draw_en <= 1;
          pix <= cannon_palette[cannon_30_out];
        end else if (cannon_num == 2'd1 && cannon_palette[cannon_45_out] != 12'h001) begin
          draw_en <= 1;
          pix <= cannon_palette[cannon_45_out];
        end else if (cannon_num == 2'd2 && cannon_palette[cannon_60_out] != 12'h001) begin
          draw_en <= 1;
          pix <= cannon_palette[cannon_60_out];
        end
      end

      if (in_target_region && target_palette[target_out] != 12'h001) begin
        draw_en <= 1;
        pix <= target_palette[target_out];
      end

      if (in_target2_region && target_palette[target2_out] != 12'h001) begin
        draw_en <= 1;
        pix <= target_palette[target2_out];
      end

      if (in_pwr_region && (hcount < (384 + (10 * launch_pwr)))) begin  // extendy bar
        draw_en <= 1;
        pix <= pwr_palette[pwr_out];
      end

      if (in_timerframe_region && timerframe_palette[timerframe_out] != 12'h001) begin
        draw_en <= 1;
        pix <= timerframe_palette[timerframe_out];
      end

      if (in_timer_region && (hcount < (394 + game_time + 1)) ) begin // doesn't draw right of hcount = 394 + game_time
        draw_en <= 1;
        pix <= timer_palette[timer_out];
      end

      if (in_cannonball_region && cannonball_shot && cannonball_palette[cannonball_out] != 12'h001) begin
        draw_en <= 1;
        pix <= cannonball_palette[cannonball_out];
      end

      if (in_banner_region) begin
        draw_en <= 1;
        pix <= banner_palette[banner_out];
      end

    end else begin
      if (in_end_region) begin
        draw_en <= 1;
        pix <= end_palette[end_out];
      end
      if (in_banner_region) begin
        draw_en <= 1;
        pix <= banner_palette[banner_out];
      end
    end

  end

  // assign current pixel values to outputs
  assign pix_r = (draw_en) ? (pix[11:8]) : 4'b0000;  //pix[3:0];
  assign pix_g = (draw_en) ? (pix[7:4]) : 4'b0000;
  assign pix_b = (draw_en) ? (pix[3:0]) : 4'b0000;

endmodule
