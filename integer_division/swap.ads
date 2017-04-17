pragma SPARK_Mode(on);

procedure SWAP(X : in out Integer; Y : in out Integer)
  with
    Pre => (if Y < 0 then X in (Integer'First - Y) .. Integer'Last else
            X in Integer'First .. (Integer'Last - Y)),
    Post => (X'Old = Y) and (Y'Old = X);
