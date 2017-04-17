pragma SPARK_Mode(on);

with Ada.Unchecked_Conversion;
with Interfaces; use Interfaces;

package body Base64 is

--     subtype ThreePartOctet is Data_Type(1..3);
--     subtype FourPartSextet is Encoded_Data_Type(1..4);


--     function Octet_To_Sextet is new Ada.Unchecked_Conversion(Source => Octet,
--                                                              Target => Sextet);
--
--     function Sextet_To_Octet is new Ada.Unchecked_Conversion(Source => Sextet,
--                                                              Target => Octet);
--
--     function ThreePartOctet_To_FourPartSextet is new Ada.Unchecked_Conversion(Source => ThreePartOctet,
--                                                                               Target => FourPartSextet);
--
--     function FourPartSextet_To_ThreePartOctet is new Ada.Unchecked_Conversion(Source => FourPartSextet,
--                                                                               Target => ThreePartOctet);

   function Encode(D : in Data_Type) return Encoded_Data_Type
   is
      encoded_data : Encoded_Data_Type(1 .. (4 * (D'Length / 3))) := (others => 0);
      encoded_data_index : Positive := 1;
      FIRST_TWO_BYTES : constant Octet := 3;
      FIRST_FOUR_BYTES : constant Octet := (2**4)-1;
      FIRST_SIX_BYTES : constant Octet := (2**6)-1;
      LAST_TWO_BYTES : constant Octet := (2**7) + (2**6);
   begin
      for n in 1..(D'Length / 3) loop
         encoded_data(encoded_data_index) := Sextet(D(n) and FIRST_SIX_BYTES);
         encoded_data(encoded_data_index+1) := Sextet(
           (Shift_Right(D(n), 6) and FIRST_TWO_BYTES) or
           Shift_Left(D(n+1) and FIRST_FOUR_BYTES, 2));
         encoded_data(encoded_data_index+2) := Sextet(
           (Shift_Right(D(n+1), 4) and FIRST_FOUR_BYTES) or
           Shift_Left(D(n+2) and FIRST_FOUR_BYTES, 4));
         encoded_data(encoded_data_index+3) := Sextet(Shift_Right(D(n+2), 2) and FIRST_SIX_BYTES);
         encoded_data_index := encoded_data_index + 4;
         pragma Loop_Variant(Increases => encoded_data_index);
      end loop;

--        for n in D'Range loop
--           if n rem 3 = 0 and n /= D'Last then
--              pragma Assert(n+2 <= D'Length);
--              threePartOctetTmp(1) := D(n);
--              threePartOctetTmp(2) := D(n+1);
--              threePartOctetTmp(3) := D(n+2);
--              fourPartSextetTmp := ThreePartOctet_To_FourPartSextet(threePartOctetTmp);
--              encoded_data(encoded_data_index) := fourPartSextetTmp(1);
--              encoded_data(encoded_data_index+1) := fourPartSextetTmp(2);
--              encoded_data(encoded_data_index+2) := fourPartSextetTmp(3);
--              encoded_data(encoded_data_index+3) := fourPartSextetTmp(4);
--              encoded_data_index := encoded_data_index + 4;
--           end if;
--        end loop;
      return encoded_data;
   end Encode;

   function Decode(E : in Encoded_Data_Type) return Data_Type
   is
      decoded_data : Data_Type(1 .. (3 * (E'Length / 4))) := (others => 0);
      decoded_data_index : Positive := 1;
      EIGHT_BYTES : constant Octet := (2**8)-1;
      FIRST_TWO_BYTES : constant Octet := 3;
      FIRST_FOUR_BYTES : constant Octet := (2**4)-1;
      FIRST_SIX_BYTES : constant Octet := (2**6)-1;
   begin
      for n in 1..(E'Length / 4) loop
         decoded_data(decoded_data_index) := (EIGHT_BYTES and Octet(E(n))) or
           Shift_Left(FIRST_TWO_BYTES and Octet(E(n+1)), 6);
         decoded_data(decoded_data_index+1) :=
           (FIRST_FOUR_BYTES and Shift_Right(Octet(E(n+1)), 2)) or
           Shift_Left(FIRST_FOUR_BYTES and Octet(E(n+2)), 4);
         decoded_data(decoded_data_index+2) :=
           (FIRST_TWO_BYTES and Shift_Right(Octet(E(n+2)), 4)) or
           Shift_Left(EIGHT_BYTES and Octet(E(n+3)), 2);
         decoded_data_index := decoded_data_index + 3;
         pragma Loop_Variant(Increases => decoded_data_index);
      end loop;
      return decoded_data;
   end Decode;

end Base64;
