struct Base64EncodeBE {
    table: [u8; 64]
}
impl Base64EncodeBE {
    /// Creates a new encoder that uses the standard Base64 Alphabet (base64) specified in RFC 4648 
    /// (https://datatracker.ietf.org/doc/html/rfc4648#section-4)
    fn new() -> Self {
        Base64EncodeBE {
            // The alphabet values here are standard UTF-8 (and ASCII) byte encodings, so the index
            // in the table is the 6-bit Base64 value, and the value at that index is the UTF-8 
            // encoding of that value.
            table: [
                65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90,// 0-25 (A-Z)
                97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122,// 26-51 (a-z)
                48, 49, 50, 51, 52, 53, 54, 55, 56, 57,// 0-9
                43,// +
                47// /
            ]
        }
    }

    fn get(self, idx: Field) -> u8 {
        self.table[idx]
    }
}

global INVALID_VALUE: u8 = 255;
struct Base64DecodeBE {
    table: [u8; 256]
}
impl Base64DecodeBE {
    /// Creates a new decoder that uses the standard Base64 Alphabet (base64) specified in RFC 4648
    /// https://datatracker.ietf.org/doc/html/rfc4648#section-4
    fn new() -> Self {
        Base64DecodeBE {
            table: [
                // 0-42
                INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE,
                INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE,
                INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE,
                INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE,
                INVALID_VALUE, INVALID_VALUE, INVALID_VALUE,
                62,// 43
                INVALID_VALUE, INVALID_VALUE, INVALID_VALUE,// 44-46
                63,// 47
                52, 53, 54, 55, 56, 57, 58, 59, 60, 61,// 48-57
                INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE,// 58-64
                0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,// 65-90 (A-Z)
                INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE,// 91-96
                26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51,// 97-122 (a-z)
                // 123-255
                INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE, INVALID_VALUE
            ]
        }
    }

    fn get(self, idx: Field) -> u8 {
        self.table[idx]
    }
}

/**
 * @brief Take an array of ASCII values and convert into base64 values
 **/
pub fn base64_encode_elements<let InputElements: u32>(input: [u8; InputElements]) -> [u8; InputElements] {
    // for some reason, if the lookup table is not defined in a struct, access costs are expensive and ROM tables aren't being used :/
    let mut Base64Encoder = Base64EncodeBE::new();

    let mut result: [u8; InputElements] = [0; InputElements];

    for i in 0..InputElements {
        result[i] = Base64Encoder.get(input[i] as Field);
    }
    result
}

/**
 * @brief Take an array of base64 values and convert into ASCII values
 **/
pub fn base64_decode_elements<let InputElements: u32>(input: [u8; InputElements]) -> [u8; InputElements] {
    // for some reason, if the lookup table is not defined in a struct, access costs are expensive and ROM tables aren't being used :/
    let mut Base64Decoder = Base64DecodeBE::new();

    let mut result: [u8; InputElements] = [0; InputElements];

    for i in 0..InputElements {
        let input_byte = input[i];
        result[i] = Base64Decoder.get(input_byte as Field);
        assert(result[i] != INVALID_VALUE, f"DecodeError: invalid symbol {input_byte}, offset {i}.");
    }
    result
}

/**
 * @brief Take an array of ASCII values and convert into *packed* byte array of base64 values
 *        Each Base64 value is 6 bits. This method will produce a byte array where data is concatenated so that there are no sparse bits
 *        (e.g. encoding 4 ASCII values produces 24 bits of Base64 data = 3 bytes of output data)
 **/
pub fn base64_decode<let InputElements: u32, let OutputBytes: u32>(input: [u8; InputElements]) -> [u8; OutputBytes] {
    let decoded: [u8; InputElements] = base64_decode_elements(input);
    // 240 bits fits 40 6-bit chunks and 30 8-bit chunks
    // we pack 40 base64 values into a field element and convert into 30 bytes
    // TODO: once we support arithmetic ops on generics, derive OutputBytes from InputBytes
    let mut result: [u8; OutputBytes] = [0; OutputBytes];
    let BASE64_ELEMENTS_PER_CHUNK: u32 = 40;
    let BYTES_PER_CHUNK: u32 = 30;
    let num_chunks = (InputElements / BASE64_ELEMENTS_PER_CHUNK)
        + (InputElements % BASE64_ELEMENTS_PER_CHUNK != 0) as u32;

    if num_chunks > 0 {
        for i in 0..num_chunks - 1 {
            let mut slice: Field = 0;
            for j in 0..BASE64_ELEMENTS_PER_CHUNK {
                slice *= 64;
                slice += decoded[i * BASE64_ELEMENTS_PER_CHUNK + j] as Field;
            }
            let slice_bytes: [u8; 30] = slice.to_be_bytes();
            for j in 0..BYTES_PER_CHUNK {
                result[i * BYTES_PER_CHUNK + j] = slice_bytes[j];
            }
        }

        let base64_elements_in_final_chunk = InputElements - ((num_chunks - 1) * BASE64_ELEMENTS_PER_CHUNK);

        let mut slice: Field = 0;
        for j in 0..base64_elements_in_final_chunk {
            slice *= 64;
            slice += decoded[(num_chunks - 1) * BASE64_ELEMENTS_PER_CHUNK + j] as Field;
        }
        for _ in base64_elements_in_final_chunk..BASE64_ELEMENTS_PER_CHUNK {
            slice *= 64;
        }
        // TODO: check is it cheaper to use a constant value in `to_be_bytes` or can we use `bytes_in_final_chunk`?
        let slice_bytes: [u8; 30] = slice.to_be_bytes();
        let num_bytes_in_final_chunk = OutputBytes - ((num_chunks - 1) * BYTES_PER_CHUNK);
        for i in 0..num_bytes_in_final_chunk {
            result[(num_chunks - 1) * BYTES_PER_CHUNK + i] = slice_bytes[i];
        }
    }

    result
}

/**
 * @brief Take an array of packed base64 encoded bytes and convert into ASCII
 **/
pub fn base64_encode<let InputBytes: u32, let OutputElements: u32>(input: [u8; InputBytes]) -> [u8; OutputElements] {
    // 240 bits fits 40 6-bit chunks and 30 8-bit chunks
    // we pack 40 base64 values into a field element and convert into 30 bytes
    // TODO: once we support arithmetic ops on generics, derive OutputBytes from InputBytes
    let mut result: [u8; OutputElements] = [0; OutputElements];
    let BASE64_ELEMENTS_PER_CHUNK: u32 = 40;
    let BYTES_PER_CHUNK: u32 = 30;
    let num_chunks = (InputBytes / BYTES_PER_CHUNK) + (InputBytes % BYTES_PER_CHUNK != 0) as u32;

    if num_chunks > 0 {
        for i in 0..num_chunks - 1 {
            let mut slice: Field = 0;
            for j in 0..BYTES_PER_CHUNK {
                slice *= 256;
                slice += input[i * BYTES_PER_CHUNK + j] as Field;
            }

            let slice_base64_chunks: [u8; 40] = slice.to_be_radix(64);
            for j in 0..BASE64_ELEMENTS_PER_CHUNK {
                result[i * BASE64_ELEMENTS_PER_CHUNK + j] = slice_base64_chunks[j];
            }
        }

        let bytes_in_final_chunk = InputBytes - ((num_chunks - 1) * BYTES_PER_CHUNK);

        let mut slice: Field = 0;
        for j in 0..bytes_in_final_chunk {
            slice *= 256;
            slice += input[(num_chunks - 1) * BYTES_PER_CHUNK + j] as Field;
        }
        for _ in bytes_in_final_chunk..BYTES_PER_CHUNK {
            slice *= 256;
        }

        // TODO: check is it cheaper to use a constant value in `to_be_bytes` or can we use `bytes_in_final_chunk`?
        let slice_base64_chunks: [u8; 40] = slice.to_be_radix(64);

        let num_elements_in_final_chunk = OutputElements - ((num_chunks - 1) * BASE64_ELEMENTS_PER_CHUNK);
        for i in 0..num_elements_in_final_chunk {
            result[(num_chunks - 1) * BASE64_ELEMENTS_PER_CHUNK + i] = slice_base64_chunks[i];
        }
        result = base64_encode_elements(result);
    }

    result
}

#[test]
fn encode_and_decode() {
    let input: str<88> = "The quick brown fox jumps over the lazy dog, while 42 ravens perch atop a rusty mailbox.";
    let base64_encoded: str<118> = "VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZywgd2hpbGUgNDIgcmF2ZW5zIHBlcmNoIGF0b3AgYSBydXN0eSBtYWlsYm94Lg";

    let encoded:[u8; 118] = base64_encode(input.as_bytes());
    assert(encoded == base64_encoded.as_bytes());

    let decoded: [u8; 88] = base64_decode(encoded);
    assert(decoded == input.as_bytes());
}

#[test]
fn test_base64_encode_elements() {
    // Raw bh: GxMlgwLiypnVrE2C0Sf4yzhcWTkAhSZ5+WERhKhXtlU=
    // Translated directly to ASCII (with the = padding character stripped)
    let ascii_expected: [u8; 43] = [
        71, 120, 77, 108, 103,
        119, 76, 105, 121, 112,
        110, 86, 114, 69, 50,
        67, 48, 83, 102, 52,
        121, 122, 104, 99, 87,
        84, 107, 65, 104, 83,
        90, 53, 43, 87, 69,
        82, 104, 75, 104, 88,
        116, 108, 85
    ];

    let input: [u8; 43] = [
        6, 49, 12, 37, 32, 48, 11, 34, 50, 41, 39, 21, 43, 4, 54, 2, 52, 18, 31, 56, 50, 51, 33, 28, 22, 19, 36, 0, 33, 18, 25, 57, 62, 22, 4, 17, 33, 10, 33, 23, 45, 37, 20
    ];

    let ascii_result = base64_encode_elements(input);

    assert(ascii_result == ascii_expected);
}

#[test]
fn test_encode_empty() {
    let input: [u8; 0] = [];
    let result = base64_encode(input);
    let expected: [u8; 0] = [];

    assert(result == expected);
}

#[test]
fn test_decode_empty() {
    let input: [u8; 0] = [];
    let expected: [u8; 0] = [];
    let result = base64_decode(input);
    assert(result == expected);
}

#[test]
fn test_encode_max_byte() {
    let input: [u8; 1] = [255];

    let result: [u8; 2] = base64_encode(input);
    let expected: [u8; 2] = [47, 119]; // "/w"
    assert(result == expected);
}

#[test]
fn test_decode_max_byte() {
    let expected: [u8; 1] = [255];

    let input: [u8; 2] = [47, 119]; // "/w"
    let result: [u8; 1] = base64_decode(input);
    assert(result == expected);
}

#[test(should_fail_with = "DecodeError: invalid symbol 255, offset 0")]
fn test_decode_invalid() {
    let input: [u8; 1] = [255];
    let _: [u8; 0] = base64_decode(input);
}

#[test]
fn test_encode_ascii() {
    // "Hello World!"
    let input: [u8; 12] = [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 33];
    // base64: SGVsbG8gV29ybGQh
    let expected: [u8; 16] = [83, 71, 86, 115, 98, 71, 56, 103, 86, 50, 57, 121, 98, 71, 81, 104];

    // all configurations should give the same encoding
    let result = base64_encode(input);
    assert(result == expected);
}

#[test]
fn test_decode_ascii() {
    // base64: SGVsbG8gV29ybGQh
    let input: [u8; 16] = [83, 71, 86, 115, 98, 71, 56, 103, 86, 50, 57, 121, 98, 71, 81, 104];
    // "Hello World!"
    let expected: [u8; 12] = [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 33];

    // all configurations should decode the same way
    let result: [u8; 12] = base64_decode(input);
    assert(result == expected);
}

#[test]
fn test_encode_utf8() {
    // non-ascii utf-8: "Hello, World!" in Japanese
    let input: [u8; 27] = [
        227, 129, 147, 227, 130, 147, 227, 129, 171, 227, 129, 161, 227, 129, 175, 227, 128, 129, 228, 184, 150, 231, 149, 140, 239, 188, 129
    ];
    // base64: 44GT44KT44Gr44Gh44Gv44CB5LiW55WM77yB
    let expected: [u8; 36] = [
        52, 52, 71, 84, 52, 52, 75, 84, 52, 52, 71, 114, 52, 52, 71, 104, 52, 52, 71, 118, 52, 52, 67, 66, 53, 76, 105, 87, 53, 53, 87, 77, 55, 55, 121, 66
    ];

    let result = base64_encode(input);
    assert(result == expected);
}

#[test]
fn test_decode_utf8() {
    // base64: 44GT44KT44Gr44Gh44Gv44CB5LiW55WM77yB
    let input: [u8; 36] = [
        52, 52, 71, 84, 52, 52, 75, 84, 52, 52, 71, 114, 52, 52, 71, 104, 52, 52, 71, 118, 52, 52, 67, 66, 53, 76, 105, 87, 53, 53, 87, 77, 55, 55, 121, 66
    ];
    // non-ascii utf-8: "Hello, World!" in Japanese
    let expected: [u8; 27] = [
        227, 129, 147, 227, 130, 147, 227, 129, 171, 227, 129, 161, 227, 129, 175, 227, 128, 129, 228, 184, 150, 231, 149, 140, 239, 188, 129
    ];

    let result: [u8; 27] = base64_decode(input);
    assert(result == expected);
}

#[test]
fn test_encode_multi_chunks() {
    let input_str = "The quick brown fox jumps over the lazy dog, while 42 ravens perch atop a rusty mailbox. Zany quilters fabricate 9 cozy blankets, as 3 jovial wizards expertly mix 5 potent elixirs. Bright neon signs flash \"OPEN 24/7\" in the misty night air, illuminating 8 vintage cars parked along Main Street. A gentle breeze carries the aroma of fresh coffee and warm cinnamon rolls from Joe's Diner, enticing 6 sleepy truckers to stop for a late-night snack. Meanwhile, 11 mischievous kittens playfully chase a ball of yarn across Mrs. Johnson's porch, their antics observed by 2 wise old owls perched on a nearby oak tree.";

    let result:[u8; 814] = base64_encode(input_str.as_bytes());
    let expected:[u8; 814] = [
        86, 71, 104, 108, 73, 72, 70, 49, 97, 87, 78, 114, 73, 71, 74, 121, 98, 51, 100, 117, 73, 71, 90, 118, 101, 67, 66, 113, 100, 87, 49, 119, 99, 121, 66, 118, 100, 109, 86, 121, 73, 72, 82, 111, 90, 83, 66, 115, 89, 88, 112, 53, 73, 71, 82, 118, 90, 121, 119, 103, 100, 50, 104, 112, 98, 71, 85, 103, 78, 68, 73, 103, 99, 109, 70, 50, 90, 87, 53, 122, 73, 72, 66, 108, 99, 109, 78, 111, 73, 71, 70, 48, 98, 51, 65, 103, 89, 83, 66, 121, 100, 88, 78, 48, 101, 83, 66, 116, 89, 87, 108, 115, 89, 109, 57, 52, 76, 105, 66, 97, 89, 87, 53, 53, 73, 72, 70, 49, 97, 87, 120, 48, 90, 88, 74, 122, 73, 71, 90, 104, 89, 110, 74, 112, 89, 50, 70, 48, 90, 83, 65, 53, 73, 71, 78, 118, 101, 110, 107, 103, 89, 109, 120, 104, 98, 109, 116, 108, 100, 72, 77, 115, 73, 71, 70, 122, 73, 68, 77, 103, 97, 109, 57, 50, 97, 87, 70, 115, 73, 72, 100, 112, 101, 109, 70, 121, 90, 72, 77, 103, 90, 88, 104, 119, 90, 88, 74, 48, 98, 72, 107, 103, 98, 87, 108, 52, 73, 68, 85, 103, 99, 71, 57, 48, 90, 87, 53, 48, 73, 71, 86, 115, 97, 88, 104, 112, 99, 110, 77, 117, 73, 69, 74, 121, 97, 87, 100, 111, 100, 67, 66, 117, 90, 87, 57, 117, 73, 72, 78, 112, 90, 50, 53, 122, 73, 71, 90, 115, 89, 88, 78, 111, 73, 67, 74, 80, 85, 69, 86, 79, 73, 68, 73, 48, 76, 122, 99, 105, 73, 71, 108, 117, 73, 72, 82, 111, 90, 83, 66, 116, 97, 88, 78, 48, 101, 83, 66, 117, 97, 87, 100, 111, 100, 67, 66, 104, 97, 88, 73, 115, 73, 71, 108, 115, 98, 72, 86, 116, 97, 87, 53, 104, 100, 71, 108, 117, 90, 121, 65, 52, 73, 72, 90, 112, 98, 110, 82, 104, 90, 50, 85, 103, 89, 50, 70, 121, 99, 121, 66, 119, 89, 88, 74, 114, 90, 87, 81, 103, 89, 87, 120, 118, 98, 109, 99, 103, 84, 87, 70, 112, 98, 105, 66, 84, 100, 72, 74, 108, 90, 88, 81, 117, 73, 69, 69, 103, 90, 50, 86, 117, 100, 71, 120, 108, 73, 71, 74, 121, 90, 87, 86, 54, 90, 83, 66, 106, 89, 88, 74, 121, 97, 87, 86, 122, 73, 72, 82, 111, 90, 83, 66, 104, 99, 109, 57, 116, 89, 83, 66, 118, 90, 105, 66, 109, 99, 109, 86, 122, 97, 67, 66, 106, 98, 50, 90, 109, 90, 87, 85, 103, 89, 87, 53, 107, 73, 72, 100, 104, 99, 109, 48, 103, 89, 50, 108, 117, 98, 109, 70, 116, 98, 50, 52, 103, 99, 109, 57, 115, 98, 72, 77, 103, 90, 110, 74, 118, 98, 83, 66, 75, 98, 50, 85, 110, 99, 121, 66, 69, 97, 87, 53, 108, 99, 105, 119, 103, 90, 87, 53, 48, 97, 87, 78, 112, 98, 109, 99, 103, 78, 105, 66, 122, 98, 71, 86, 108, 99, 72, 107, 103, 100, 72, 74, 49, 89, 50, 116, 108, 99, 110, 77, 103, 100, 71, 56, 103, 99, 51, 82, 118, 99, 67, 66, 109, 98, 51, 73, 103, 89, 83, 66, 115, 89, 88, 82, 108, 76, 87, 53, 112, 90, 50, 104, 48, 73, 72, 78, 117, 89, 87, 78, 114, 76, 105, 66, 78, 90, 87, 70, 117, 100, 50, 104, 112, 98, 71, 85, 115, 73, 68, 69, 120, 73, 71, 49, 112, 99, 50, 78, 111, 97, 87, 86, 50, 98, 51, 86, 122, 73, 71, 116, 112, 100, 72, 82, 108, 98, 110, 77, 103, 99, 71, 120, 104, 101, 87, 90, 49, 98, 71, 120, 53, 73, 71, 78, 111, 89, 88, 78, 108, 73, 71, 69, 103, 89, 109, 70, 115, 98, 67, 66, 118, 90, 105, 66, 53, 89, 88, 74, 117, 73, 71, 70, 106, 99, 109, 57, 122, 99, 121, 66, 78, 99, 110, 77, 117, 73, 69, 112, 118, 97, 71, 53, 122, 98, 50, 52, 110, 99, 121, 66, 119, 98, 51, 74, 106, 97, 67, 119, 103, 100, 71, 104, 108, 97, 88, 73, 103, 89, 87, 53, 48, 97, 87, 78, 122, 73, 71, 57, 105, 99, 50, 86, 121, 100, 109, 86, 107, 73, 71, 74, 53, 73, 68, 73, 103, 100, 50, 108, 122, 90, 83, 66, 118, 98, 71, 81, 103, 98, 51, 100, 115, 99, 121, 66, 119, 90, 88, 74, 106, 97, 71, 86, 107, 73, 71, 57, 117, 73, 71, 69, 103, 98, 109, 86, 104, 99, 109, 74, 53, 73, 71, 57, 104, 97, 121, 66, 48, 99, 109, 86, 108, 76, 103
    ];
    assert(result == expected);
}

#[test]
fn test_decode_multi_chunks() {
    let input:[u8; 814] = [
        86, 71, 104, 108, 73, 72, 70, 49, 97, 87, 78, 114, 73, 71, 74, 121, 98, 51, 100, 117, 73, 71, 90, 118, 101, 67, 66, 113, 100, 87, 49, 119, 99, 121, 66, 118, 100, 109, 86, 121, 73, 72, 82, 111, 90, 83, 66, 115, 89, 88, 112, 53, 73, 71, 82, 118, 90, 121, 119, 103, 100, 50, 104, 112, 98, 71, 85, 103, 78, 68, 73, 103, 99, 109, 70, 50, 90, 87, 53, 122, 73, 72, 66, 108, 99, 109, 78, 111, 73, 71, 70, 48, 98, 51, 65, 103, 89, 83, 66, 121, 100, 88, 78, 48, 101, 83, 66, 116, 89, 87, 108, 115, 89, 109, 57, 52, 76, 105, 66, 97, 89, 87, 53, 53, 73, 72, 70, 49, 97, 87, 120, 48, 90, 88, 74, 122, 73, 71, 90, 104, 89, 110, 74, 112, 89, 50, 70, 48, 90, 83, 65, 53, 73, 71, 78, 118, 101, 110, 107, 103, 89, 109, 120, 104, 98, 109, 116, 108, 100, 72, 77, 115, 73, 71, 70, 122, 73, 68, 77, 103, 97, 109, 57, 50, 97, 87, 70, 115, 73, 72, 100, 112, 101, 109, 70, 121, 90, 72, 77, 103, 90, 88, 104, 119, 90, 88, 74, 48, 98, 72, 107, 103, 98, 87, 108, 52, 73, 68, 85, 103, 99, 71, 57, 48, 90, 87, 53, 48, 73, 71, 86, 115, 97, 88, 104, 112, 99, 110, 77, 117, 73, 69, 74, 121, 97, 87, 100, 111, 100, 67, 66, 117, 90, 87, 57, 117, 73, 72, 78, 112, 90, 50, 53, 122, 73, 71, 90, 115, 89, 88, 78, 111, 73, 67, 74, 80, 85, 69, 86, 79, 73, 68, 73, 48, 76, 122, 99, 105, 73, 71, 108, 117, 73, 72, 82, 111, 90, 83, 66, 116, 97, 88, 78, 48, 101, 83, 66, 117, 97, 87, 100, 111, 100, 67, 66, 104, 97, 88, 73, 115, 73, 71, 108, 115, 98, 72, 86, 116, 97, 87, 53, 104, 100, 71, 108, 117, 90, 121, 65, 52, 73, 72, 90, 112, 98, 110, 82, 104, 90, 50, 85, 103, 89, 50, 70, 121, 99, 121, 66, 119, 89, 88, 74, 114, 90, 87, 81, 103, 89, 87, 120, 118, 98, 109, 99, 103, 84, 87, 70, 112, 98, 105, 66, 84, 100, 72, 74, 108, 90, 88, 81, 117, 73, 69, 69, 103, 90, 50, 86, 117, 100, 71, 120, 108, 73, 71, 74, 121, 90, 87, 86, 54, 90, 83, 66, 106, 89, 88, 74, 121, 97, 87, 86, 122, 73, 72, 82, 111, 90, 83, 66, 104, 99, 109, 57, 116, 89, 83, 66, 118, 90, 105, 66, 109, 99, 109, 86, 122, 97, 67, 66, 106, 98, 50, 90, 109, 90, 87, 85, 103, 89, 87, 53, 107, 73, 72, 100, 104, 99, 109, 48, 103, 89, 50, 108, 117, 98, 109, 70, 116, 98, 50, 52, 103, 99, 109, 57, 115, 98, 72, 77, 103, 90, 110, 74, 118, 98, 83, 66, 75, 98, 50, 85, 110, 99, 121, 66, 69, 97, 87, 53, 108, 99, 105, 119, 103, 90, 87, 53, 48, 97, 87, 78, 112, 98, 109, 99, 103, 78, 105, 66, 122, 98, 71, 86, 108, 99, 72, 107, 103, 100, 72, 74, 49, 89, 50, 116, 108, 99, 110, 77, 103, 100, 71, 56, 103, 99, 51, 82, 118, 99, 67, 66, 109, 98, 51, 73, 103, 89, 83, 66, 115, 89, 88, 82, 108, 76, 87, 53, 112, 90, 50, 104, 48, 73, 72, 78, 117, 89, 87, 78, 114, 76, 105, 66, 78, 90, 87, 70, 117, 100, 50, 104, 112, 98, 71, 85, 115, 73, 68, 69, 120, 73, 71, 49, 112, 99, 50, 78, 111, 97, 87, 86, 50, 98, 51, 86, 122, 73, 71, 116, 112, 100, 72, 82, 108, 98, 110, 77, 103, 99, 71, 120, 104, 101, 87, 90, 49, 98, 71, 120, 53, 73, 71, 78, 111, 89, 88, 78, 108, 73, 71, 69, 103, 89, 109, 70, 115, 98, 67, 66, 118, 90, 105, 66, 53, 89, 88, 74, 117, 73, 71, 70, 106, 99, 109, 57, 122, 99, 121, 66, 78, 99, 110, 77, 117, 73, 69, 112, 118, 97, 71, 53, 122, 98, 50, 52, 110, 99, 121, 66, 119, 98, 51, 74, 106, 97, 67, 119, 103, 100, 71, 104, 108, 97, 88, 73, 103, 89, 87, 53, 48, 97, 87, 78, 122, 73, 71, 57, 105, 99, 50, 86, 121, 100, 109, 86, 107, 73, 71, 74, 53, 73, 68, 73, 103, 100, 50, 108, 122, 90, 83, 66, 118, 98, 71, 81, 103, 98, 51, 100, 115, 99, 121, 66, 119, 90, 88, 74, 106, 97, 71, 86, 107, 73, 71, 57, 117, 73, 71, 69, 103, 98, 109, 86, 104, 99, 109, 74, 53, 73, 71, 57, 104, 97, 121, 66, 48, 99, 109, 86, 108, 76, 103
    ];
    let result:[u8; 610] = base64_decode(input);
    let expected = "The quick brown fox jumps over the lazy dog, while 42 ravens perch atop a rusty mailbox. Zany quilters fabricate 9 cozy blankets, as 3 jovial wizards expertly mix 5 potent elixirs. Bright neon signs flash \"OPEN 24/7\" in the misty night air, illuminating 8 vintage cars parked along Main Street. A gentle breeze carries the aroma of fresh coffee and warm cinnamon rolls from Joe's Diner, enticing 6 sleepy truckers to stop for a late-night snack. Meanwhile, 11 mischievous kittens playfully chase a ball of yarn across Mrs. Johnson's porch, their antics observed by 2 wise old owls perched on a nearby oak tree.";

    assert(result == expected.as_bytes());
}

// TODO: support padding
// this test should fail, because padding is not supported
#[test(should_fail)]
fn test_base64_decode_with_padding() {
    // Raw bh: GxMlgwLiypnVrE2C0Sf4yzhcWTkAhSZ5+WERhKhXtlU=
    // Translated directly to ASCII
    let input: [u8; 44] = [
        71, 120, 77, 108, 103,
        119, 76, 105, 121, 112,
        110, 86, 114, 69, 50,
        67, 48, 83, 102, 52,
        121, 122, 104, 99, 87,
        84, 107, 65, 104, 83,
        90, 53, 43, 87, 69,
        82, 104, 75, 104, 88,
        116, 108, 85, 61
    ];

    let result: [u8; 32] = base64_decode(input);
    let expected: [u8; 32] = [
        27, 19, 37, 131, 2, 226, 202, 153, 213, 172,
        77, 130, 209, 39, 248, 203, 56, 92, 89, 57,
        0, 133, 38, 121, 249, 97, 17, 132, 168, 87,
        182, 85
    ];
    assert(result == expected);
}

#[test]
fn test_base64_encode() {
    // Raw bh: GxMlgwLiypnVrE2C0Sf4yzhcWTkAhSZ5+WERhKhXtlU
    // Translated directly to ASCII (with padding byte character stripped)
    let expected: [u8; 43] = [
        71, 120, 77, 108, 103,
        119, 76, 105, 121, 112,
        110, 86, 114, 69, 50,
        67, 48, 83, 102, 52,
        121, 122, 104, 99, 87,
        84, 107, 65, 104, 83,
        90, 53, 43, 87, 69,
        82, 104, 75, 104, 88,
        116, 108, 85
    ];

    let input: [u8; 32] = [
        27, 19, 37, 131, 2, 226, 202, 153, 213, 172,
        77, 130, 209, 39, 248, 203, 56, 92, 89, 57,
        0, 133, 38, 121, 249, 97, 17, 132, 168, 87,
        182, 85
    ];

    let result: [u8; 43] = base64_encode(input);
    assert(result == expected);
}

#[test]
fn test_base64_encode_slash() {
    let input: [u8; 1] = [63]; // '/' in Base64
    let result: [u8; 1] = base64_encode_elements(input);

    // Should map to '/' in ASCII, which is 47
    assert(result[0] == 47);
}
