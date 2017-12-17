with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;

procedure TrabalhoAda is

   procedure Cool_Print(text: in String; value: in Integer) is
   begin
      Put_Line(text & Integer'Image(value));
   end Cool_Print;


   --- Channel
   protected type Channel is
      procedure Send(value: in Integer);
      entry Receive(value: out Integer);
   private
      Empty : Boolean := True;
      Slot : Integer;
   end Channel;

   protected body Channel is

      procedure Send(value: in Integer) is
      begin
         slot := value;
         Empty := False;
      end Send;

      entry Receive(value: out Integer) when not Empty is
      begin
         value := slot;
         Empty := True;
      end Receive;

   end Channel;


   -- Channels
   type ChannelArray is array(1..6) of Channel;
   channels: ChannelArray;

   type vector is array(1..3) of Integer;


   -- Task A
   task type TaskA;
   task body TaskA is
      result : Integer;
      response : Integer;
   begin
      result := 667; -- Simulated computation
      Cool_Print("Taskr A will send: ", result);
      channels(1).Send(result);
      Cool_Print("Taskr A sent:", result);
      channels(4).Receive(response);
      Cool_Print("Taskr A received: ", response);
      if response = 0 then
         Put_Line("Task A got it right! =)");
      else
         Put_Line("Task A got it wrong! =(");
      end if;
   end TaskA;

   -- Task B
   task type TaskB;
   task body TaskB is
      result : Integer;
      response : Integer;
   begin
      result := 666; -- Simulated computation
      Cool_Print("Taskr B will send: ", result);
      channels(2).Send(result);
      Cool_Print("Taskr B sent:", result);
      channels(5).Receive(response);
      Cool_Print("Taskr B received: ", response);
      if response = 0 then
         Put_Line("Task B got it right! =)");
      else
         Put_Line("Task B got it wrong! =(");
      end if;
   end TaskB;

   -- Task C
   task type TaskC;
   task body TaskC is
      result : Integer;
      response : Integer;
   begin
      result := 666; -- Simulated computation
      Cool_Print("Taskr C will send: ", result);
      channels(3).Send(result);
      Cool_Print("Taskr C sent:", result);
      channels(6).Receive(response);
      Cool_Print("Taskr C received: ", response);
      if response = 0 then
         Put_Line("Task C got it right! =)");
      else
         Put_Line("Task C got it wrong! =(");
      end if;
   end TaskC;


   -- Compares a given vector of results and writes the wrong index to the out variable
   procedure CompareResults(results: in vector; index: out Integer) is
   begin
      if results(1) = results(2) and results(2) = results(3) then
         index := 0;
      elsif results(1) = results(2) then
         index := 3;
      elsif results(1) = results(3) then
         index := 2;
      elsif results(2) = results(3) then
         index := 1;
      else
         index := -1;
      end if;
   end CompareResults;


   task type Driver;
   task body Driver is
      wrong : Integer;
      results : vector;
   begin

      -- Receiving Results
      channels(1).Receive(results(1));
      Cool_Print("Driver received from Task A :", results(1));

      channels(2).Receive(results(2));
      Cool_Print("Driver received from Task B :", results(2));

      channels(3).Receive(results(3));
      Cool_Print("Driver received from Task C :", results(3));

      -- Comparing results
      CompareResults(results, wrong);

      -- Sending responses
      For_Loop:
      for I in Integer range 1..3 loop
         if I = wrong then
            channels(I + 3).Send(1);
         else
            channels(I + 3).Send(0);
         end if;
      end loop For_Loop;

      channels(4).Send(0);
      channels(5).Send(0);
      channels(6).Send(0);

   end Driver;

   -- Main Declarations
   A: TaskA;
   B: TaskB;
   C: TaskC;
   D: Driver;

begin
   null;
end TrabalhoAda;
