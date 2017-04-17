package body max with SPARK_Mode is

   function Maximum(A : in Vector) return Integer
   is
      MaxValue : Integer := A(A'First);
   begin
      for Index in A'Range loop
         if A(Index) > MaxValue then
            MaxValue := A(Index);
         end if;

         pragma Loop_Invariant(for all i in A'First..Index => A(i) <= MaxValue);
         pragma Loop_Invariant(for some i in A'First..Index => A(i) = MaxValue);
         pragma Loop_Variant(Increases => Index);
      end loop;
      return MaxValue;
   end Maximum;

end max;
