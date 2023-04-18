use dep::std;


struct PieceData {
    x: u8,
    y: u8,
    piece_type: u8,
    is_alive: bool,
    is_lit: bool,
}

fn get_vision_conditions_for_piece(piece: PieceData) -> [bool;64] {
    let can_light = piece.is_alive & piece.is_lit;
    let mut x_vision: [bool;8] = [false,false,false,false,false,false,false,false];
    let mut y_vision: [bool;8] = [false,false,false,false,false,false,false,false];
    let mut board_vision: [bool; 64] = [
        false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false
    ];
    x_vision[0] = (piece.x < 3) & can_light;
    x_vision[1] = (piece.x < 4) & can_light;
    x_vision[2] = (piece.x < 5) & can_light;
    x_vision[3] = (piece.x < 6 & piece.x > 0) & can_light;
    x_vision[4] = (piece.x < 7 & piece.x > 1) & can_light;
    x_vision[5] = (piece.x > 2) & can_light;
    x_vision[6] = (piece.x > 3) & can_light;
    x_vision[7] = (piece.x > 4) & can_light;

    y_vision[0] = (piece.x < 3) & can_light;
    y_vision[1] = (piece.x < 4) & can_light;
    y_vision[2] = (piece.x < 5) & can_light;
    y_vision[3] = (piece.x < 6 & piece.x > 0) & can_light;
    y_vision[4] = (piece.x < 7 & piece.x > 1) & can_light;
    y_vision[5] = (piece.x > 2) & can_light;
    y_vision[6] = (piece.x > 3) & can_light;
    y_vision[7] = (piece.x > 4) & can_light;

    for i in 0 .. 8 {
        for j in 0 .. 8 {
            board_vision[i + j * 8] = x_vision[i] & y_vision[i];
        }
    }
    board_vision
}


fn convert_piece_data_to_field(p: PieceData) -> Field {
    let a: comptime Field = 256;
    let b: comptime Field = a * a;
    let c: comptime Field = a * a * a;
    let d: comptime Field = c * 2;

    let x = p.x as Field;
    let y = p.y as Field;
    let piece_type = p.piece_type as Field;
    let is_alive = p.is_alive as Field;
    let is_lit = p.is_lit as Field;
    x + y * a + piece_type * b + is_alive * c + is_lit * d
}

fn commit_to_piece_data(
    p0: PieceData,
    p1: PieceData,
    p2: PieceData,
    p3: PieceData,
    p4: PieceData,
    p5: PieceData,
    p6: PieceData,
    p7: PieceData,
    p8: PieceData,
    p9: PieceData,
    p10: PieceData,
    p11: PieceData,
    p12: PieceData,
    p13: PieceData,
    p14: PieceData,
    p15: PieceData
) -> Field {
    let mut f0 : Field = 0;
    let mut f1 : Field = 0;
    let scaling_factor: comptime Field = 256 * 256 * 256 * 4;

    {
        let mut ele = convert_piece_data_to_field(p0);
        f0 += ele;
        ele = convert_piece_data_to_field(p1);
        f0 *= scaling_factor;
        f0 += ele;
        ele = convert_piece_data_to_field(p2);
        f0 *= scaling_factor;
        f0 += ele;
        ele = convert_piece_data_to_field(p3);
        f0 *= scaling_factor;
        f0 += ele;
        ele = convert_piece_data_to_field(p4);
        f0 *= scaling_factor;
        f0 += ele;
        ele = convert_piece_data_to_field(p5);
        f0 *= scaling_factor;
        f0 += ele;
        ele = convert_piece_data_to_field(p6);
        f0 *= scaling_factor;
        f0 += ele;
        ele = convert_piece_data_to_field(p7);
        f0 *= scaling_factor;
        f0 += ele;
    }
    {
        let mut ele = convert_piece_data_to_field(p8);
        f1 += ele;
        ele = convert_piece_data_to_field(p9);
        f1 *= scaling_factor;
        f1 += ele;
        ele = convert_piece_data_to_field(p10);
        f1 *= scaling_factor;
        f1 += ele;
        ele = convert_piece_data_to_field(p11);
        f1 *= scaling_factor;
        f1 += ele;
        ele = convert_piece_data_to_field(p12);
        f1 *= scaling_factor;
        f1 += ele;
        ele = convert_piece_data_to_field(p13);
        f1 *= scaling_factor;
        f1 += ele;
        ele = convert_piece_data_to_field(p14);
        f1 *= scaling_factor;
        f1 += ele;
        ele = convert_piece_data_to_field(p15);
        f1 *= scaling_factor;
        f1 += ele;
    }
    std::hash::pedersen([f0, f1])[0]
}

fn move_pawn(pawn: mut PieceData, new_x: u8, new_y: u8)
{
    bool x_valid = pawn.x == new_x;
    // pawn.y == 7 if black
    bool y_valid = (new_y - pawn.y) < 2 | (new_y - pawn.y) < 3 & pawn.y == 1;

    // check for collisions
}

fn select_piece(
    p0: PieceData,
    p1: PieceData,
    p2: PieceData,
    p3: PieceData,
    p4: PieceData,
    p5: PieceData,
    p6: PieceData,
    p7: PieceData,
    p8: PieceData,
    p9: PieceData,
    p10: PieceData,
    p11: PieceData,
    p12: PieceData,
    p13: PieceData,
    p14: PieceData,
    p15: PieceData,
    move_bits: [bool;4]
) -> PieceData {
    let mut res : PieceData = p0;
    let mut predicates: [bool; 16] = [
        false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false
    ];
    predicates[0] = !move_bits[3] & !move_bits[2] & !move_bits[1] & !move_bits[0];
    predicates[1] = !move_bits[3] & !move_bits[2] & !move_bits[1] & move_bits[0];
    predicates[2] = !move_bits[3] & !move_bits[2] & move_bits[1] & !move_bits[0];
    predicates[3] = !move_bits[3] & !move_bits[2] & move_bits[1] & move_bits[0];
    predicates[4] = !move_bits[3] & move_bits[2] & !move_bits[1] & !move_bits[0];
    predicates[5] = !move_bits[3] & move_bits[2] & !move_bits[1] & move_bits[0];
    predicates[6] = !move_bits[3] & move_bits[2] & move_bits[1] & !move_bits[0];
    predicates[7] = !move_bits[3] & move_bits[2] & move_bits[1] & move_bits[0];
    predicates[8] = move_bits[3] & !move_bits[2] & !move_bits[1] & !move_bits[0];
    predicates[9] = move_bits[3] & !move_bits[2] & !move_bits[1] & move_bits[0];
    predicates[10] = move_bits[3] & !move_bits[2] & move_bits[1] & !move_bits[0];
    predicates[11] = move_bits[3] & !move_bits[2] & move_bits[1] & move_bits[0];
    predicates[12] = move_bits[3] & move_bits[2] & !move_bits[1] & !move_bits[0];
    predicates[13] = move_bits[3] & move_bits[2] & !move_bits[1] & move_bits[0];
    predicates[14] = move_bits[3] & move_bits[2] & move_bits[1] & !move_bits[0];
    predicates[15] = move_bits[3] & move_bits[2] & move_bits[1] & move_bits[0];

    if (predicates[0]) {
        res = p0;
    }

    if (predicates[1]) {
        res = p1;
    }
    if (predicates[2]) {
        res = p2;
    }
    if (predicates[3]) {
        res = p3;
    }
    if (predicates[4]) {
        res = p4;
    }
    if (predicates[5]) {
        res = p5;
    }
    if (predicates[6]) {
        res = p6;
    }
    if (predicates[7]) {
        res = p7;
    }
    if (predicates[8]) {
        res = p8;
    }
    if (predicates[9]) {
        res = p9;
    }
    if (predicates[10]) {
        res = p10;
    }
    if (predicates[11]) {
        res = p11;
    }
    if (predicates[12]) {
        res = p12;
    }
    if (predicates[13]) {
        res = p13;
    }
    if (predicates[14]) {
        res = p14;
    }
    if (predicates[15]) {
        res = p15;
    }

    constrain(res.is_alive == false);

    res
}

/**
 * @brief zk chess entry function
 * Very incomplete!
 * needs the following:
 * 1: move logic that updates the player's PieceData
 * 2: output_player_commitment of their moved state
 * 3: computation of player's public piece state using board_vision
 * 4: opponent's public piece state from previous turn
 *
 * TODO: pack the public inputs into as few field elements as possible (e.g. PieceData can be represented in 11 bits :o)
 */
fn main(
    p0: PieceData,
    p1: PieceData,
    p2: PieceData,
    p3: PieceData,
    p4: PieceData,
    p5: PieceData,
    p6: PieceData,
    p7: PieceData,
    p8: PieceData,
    p9: PieceData,
    p10: PieceData,
    p11: PieceData,
    p12: PieceData,
    p13: PieceData,
    p14: PieceData,
    p15: PieceData,
    move_bits: [bool; 4], // integer from 0 to 15 that indicates which piece the Player is moving
    // enemy_vision: [bool; 64],
    player_commitment : pub Field // a hiding commitment to player's pieces (TODO: needs a secret to be hiding :o)
    // enemy_commitment
    // turn_counter
    // opponent_p0 : pub PieceData,
    // opponent_p1 : pub PieceData,
    // opponent_p2 : pub PieceData,
    // opponent_p3 : pub PieceData,
    // opponent_p4 : pub PieceData,
    // opponent_p5 : pub PieceData,
    // opponent_p6 : pub PieceData,
    // opponent_p7 : pub PieceData,
    // opponent_p8 : pub PieceData,
    // opponent_p9 : pub PieceData,
    // opponent_p10 : pub PieceData,
    // opponent_p11 : pub PieceData,
    // opponent_p12 : pub PieceData,
    // opponent_p13 : pub PieceData,
    // opponent_p14 : pub PieceData,
    // opponent_p15 : pub PieceData,
) {
    let v0 = get_vision_conditions_for_piece(p0);
    let v1 = get_vision_conditions_for_piece(p1);
    let v2 = get_vision_conditions_for_piece(p2);
    let v3 = get_vision_conditions_for_piece(p3);
    let v4 = get_vision_conditions_for_piece(p4);
    let v5 = get_vision_conditions_for_piece(p5);
    let v6 = get_vision_conditions_for_piece(p6);
    let v7 = get_vision_conditions_for_piece(p7);
    let v8 = get_vision_conditions_for_piece(p8);
    let v9 = get_vision_conditions_for_piece(p9);
    let v10 = get_vision_conditions_for_piece(p10);
    let v11 = get_vision_conditions_for_piece(p11);
    let v12 = get_vision_conditions_for_piece(p12);
    let v13 = get_vision_conditions_for_piece(p13);
    let v14 = get_vision_conditions_for_piece(p14);
    let v15 = get_vision_conditions_for_piece(p15);

    let mut board_vision : [bool; 64] = [
        false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false,
        false,false,false,false,false,false,false,false
    ];

    for i in 0 .. 64 {
        board_vision[i] = v0[i] & v1[i] & v2[i] & v3[i] & v4[i] & v5[i] & v6[i] & v7[i] & v8[i] & v9[i] & v10[i] & v11[i] & v12[i] & v13[i] & v14[i] & v15[i];
        constrain board_vision[i] == false;
    }
    let res = commit_to_piece_data(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15);

    let move_piece = select_piece(p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,p11,p12,p13,p14,p15, move_bits);

    constrain move_piece.x == 0;
    constrain move_piece.y == 0;
    constrain move_piece.piece_type == 0;
    constrain move_piece.is_alive == false;
    constrain move_piece.is_lit == false;

    constrain res == player_commitment;
}