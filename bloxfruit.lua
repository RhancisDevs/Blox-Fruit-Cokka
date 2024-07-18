--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.6) ~  Much Love, Ferib 

]]--

local StrToNumber = tonumber;
local Byte = string.byte;
local Char = string.char;
local Sub = string.sub;
local Subg = string.gsub;
local Rep = string.rep;
local Concat = table.concat;
local Insert = table.insert;
local LDExp = math.ldexp;
local GetFEnv = getfenv or function()
	return _ENV;
end;
local Setmetatable = setmetatable;
local PCall = pcall;
local Select = select;
local Unpack = unpack or table.unpack;
local ToNumber = tonumber;
local function VMCall(ByteString, vmenv, ...)
	local DIP = 1;
	local repeatNext;
	ByteString = Subg(Sub(ByteString, 5), "..", function(byte)
		if (Byte(byte, 2) == 79) then
			repeatNext = StrToNumber(Sub(byte, 1, 1));
			return "";
		else
			local FlatIdent_76979 = 0;
			local a;
			while true do
				if (FlatIdent_76979 == 0) then
					a = Char(StrToNumber(byte, 16));
					if repeatNext then
						local FlatIdent_69270 = 0;
						local b;
						while true do
							if (FlatIdent_69270 == 1) then
								return b;
							end
							if (FlatIdent_69270 == 0) then
								b = Rep(a, repeatNext);
								repeatNext = nil;
								FlatIdent_69270 = 1;
							end
						end
					else
						return a;
					end
					break;
				end
			end
		end
	end);
	local function gBit(Bit, Start, End)
		if End then
			local Res = (Bit / (2 ^ (Start - 1))) % (2 ^ (((End - 1) - (Start - 1)) + 1));
			return Res - (Res % 1);
		else
			local Plc = 2 ^ (Start - 1);
			return (((Bit % (Plc + Plc)) >= Plc) and 1) or 0;
		end
	end
	local function gBits8()
		local a = Byte(ByteString, DIP, DIP);
		DIP = DIP + 1;
		return a;
	end
	local function gBits16()
		local a, b = Byte(ByteString, DIP, DIP + 2);
		DIP = DIP + 2;
		return (b * 256) + a;
	end
	local function gBits32()
		local a, b, c, d = Byte(ByteString, DIP, DIP + 3);
		DIP = DIP + 4;
		return (d * 16777216) + (c * 65536) + (b * 256) + a;
	end
	local function gFloat()
		local FlatIdent_7126A = 0;
		local Left;
		local Right;
		local IsNormal;
		local Mantissa;
		local Exponent;
		local Sign;
		while true do
			if (FlatIdent_7126A == 1) then
				IsNormal = 1;
				Mantissa = (gBit(Right, 1, 20) * (2 ^ 32)) + Left;
				FlatIdent_7126A = 2;
			end
			if (FlatIdent_7126A == 3) then
				if (Exponent == 0) then
					if (Mantissa == 0) then
						return Sign * 0;
					else
						local FlatIdent_44839 = 0;
						while true do
							if (FlatIdent_44839 == 0) then
								Exponent = 1;
								IsNormal = 0;
								break;
							end
						end
					end
				elseif (Exponent == 2047) then
					return ((Mantissa == 0) and (Sign * (1 / 0))) or (Sign * NaN);
				end
				return LDExp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / (2 ^ 52)));
			end
			if (FlatIdent_7126A == 0) then
				Left = gBits32();
				Right = gBits32();
				FlatIdent_7126A = 1;
			end
			if (FlatIdent_7126A == 2) then
				Exponent = gBit(Right, 21, 31);
				Sign = ((gBit(Right, 32) == 1) and -1) or 1;
				FlatIdent_7126A = 3;
			end
		end
	end
	local function gString(Len)
		local Str;
		if not Len then
			local FlatIdent_25011 = 0;
			while true do
				if (FlatIdent_25011 == 0) then
					Len = gBits32();
					if (Len == 0) then
						return "";
					end
					break;
				end
			end
		end
		Str = Sub(ByteString, DIP, (DIP + Len) - 1);
		DIP = DIP + Len;
		local FStr = {};
		for Idx = 1, #Str do
			FStr[Idx] = Char(Byte(Sub(Str, Idx, Idx)));
		end
		return Concat(FStr);
	end
	local gInt = gBits32;
	local function _R(...)
		return {...}, Select("#", ...);
	end
	local function Deserialize()
		local FlatIdent_7DD24 = 0;
		local Instrs;
		local Functions;
		local Lines;
		local Chunk;
		local ConstCount;
		local Consts;
		while true do
			if (2 == FlatIdent_7DD24) then
				for Idx = 1, gBits32() do
					local FlatIdent_104D4 = 0;
					local Descriptor;
					while true do
						if (FlatIdent_104D4 == 0) then
							Descriptor = gBits8();
							if (gBit(Descriptor, 1, 1) == 0) then
								local FlatIdent_940A0 = 0;
								local Type;
								local Mask;
								local Inst;
								while true do
									if (1 == FlatIdent_940A0) then
										Inst = {gBits16(),gBits16(),nil,nil};
										if (Type == 0) then
											Inst[3] = gBits16();
											Inst[4] = gBits16();
										elseif (Type == 1) then
											Inst[3] = gBits32();
										elseif (Type == 2) then
											Inst[3] = gBits32() - (2 ^ 16);
										elseif (Type == 3) then
											Inst[3] = gBits32() - (2 ^ 16);
											Inst[4] = gBits16();
										end
										FlatIdent_940A0 = 2;
									end
									if (FlatIdent_940A0 == 2) then
										if (gBit(Mask, 1, 1) == 1) then
											Inst[2] = Consts[Inst[2]];
										end
										if (gBit(Mask, 2, 2) == 1) then
											Inst[3] = Consts[Inst[3]];
										end
										FlatIdent_940A0 = 3;
									end
									if (FlatIdent_940A0 == 0) then
										Type = gBit(Descriptor, 2, 3);
										Mask = gBit(Descriptor, 4, 6);
										FlatIdent_940A0 = 1;
									end
									if (FlatIdent_940A0 == 3) then
										if (gBit(Mask, 3, 3) == 1) then
											Inst[4] = Consts[Inst[4]];
										end
										Instrs[Idx] = Inst;
										break;
									end
								end
							end
							break;
						end
					end
				end
				for Idx = 1, gBits32() do
					Functions[Idx - 1] = Deserialize();
				end
				return Chunk;
			end
			if (FlatIdent_7DD24 == 1) then
				ConstCount = gBits32();
				Consts = {};
				for Idx = 1, ConstCount do
					local Type = gBits8();
					local Cons;
					if (Type == 1) then
						Cons = gBits8() ~= 0;
					elseif (Type == 2) then
						Cons = gFloat();
					elseif (Type == 3) then
						Cons = gString();
					end
					Consts[Idx] = Cons;
				end
				Chunk[3] = gBits8();
				FlatIdent_7DD24 = 2;
			end
			if (FlatIdent_7DD24 == 0) then
				Instrs = {};
				Functions = {};
				Lines = {};
				Chunk = {Instrs,Functions,nil,Lines};
				FlatIdent_7DD24 = 1;
			end
		end
	end
	local function Wrap(Chunk, Upvalues, Env)
		local Instr = Chunk[1];
		local Proto = Chunk[2];
		local Params = Chunk[3];
		return function(...)
			local Instr = Instr;
			local Proto = Proto;
			local Params = Params;
			local _R = _R;
			local VIP = 1;
			local Top = -1;
			local Vararg = {};
			local Args = {...};
			local PCount = Select("#", ...) - 1;
			local Lupvals = {};
			local Stk = {};
			for Idx = 0, PCount do
				if (Idx >= Params) then
					Vararg[Idx - Params] = Args[Idx + 1];
				else
					Stk[Idx] = Args[Idx + 1];
				end
			end
			local Varargsz = (PCount - Params) + 1;
			local Inst;
			local Enum;
			while true do
				Inst = Instr[VIP];
				Enum = Inst[1];
				if (Enum <= 16) then
					if (Enum <= 7) then
						if (Enum <= 3) then
							if (Enum <= 1) then
								if (Enum > 0) then
									local FlatIdent_9147D = 0;
									local B;
									local A;
									while true do
										if (FlatIdent_9147D == 0) then
											B = nil;
											A = nil;
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											FlatIdent_9147D = 1;
										end
										if (FlatIdent_9147D == 8) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Inst[3] ~= 0;
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_9147D = 9;
										end
										if (FlatIdent_9147D == 7) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
											FlatIdent_9147D = 8;
										end
										if (FlatIdent_9147D == 6) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_9147D = 7;
										end
										if (FlatIdent_9147D == 1) then
											Stk[A] = B[Inst[4]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_9147D = 2;
										end
										if (FlatIdent_9147D == 4) then
											Inst = Instr[VIP];
											A = Inst[2];
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											FlatIdent_9147D = 5;
										end
										if (FlatIdent_9147D == 5) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_9147D = 6;
										end
										if (FlatIdent_9147D == 3) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Upvalues[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_9147D = 4;
										end
										if (FlatIdent_9147D == 2) then
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_9147D = 3;
										end
										if (FlatIdent_9147D == 9) then
											Stk[Inst[2]] = Stk[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											Stk[A](Unpack(Stk, A + 1, Inst[3]));
											FlatIdent_9147D = 10;
										end
										if (FlatIdent_9147D == 10) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											VIP = Inst[3];
											break;
										end
									end
								else
									local A = Inst[2];
									local B = Stk[Inst[3]];
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
								end
							elseif (Enum == 2) then
								local A = Inst[2];
								local T = Stk[A];
								for Idx = A + 1, Inst[3] do
									Insert(T, Stk[Idx]);
								end
							elseif (Inst[2] == Stk[Inst[4]]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						elseif (Enum <= 5) then
							if (Enum == 4) then
								local A = Inst[2];
								local T = Stk[A];
								local B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							else
								do
									return;
								end
							end
						elseif (Enum == 6) then
							local FlatIdent_9622C = 0;
							local A;
							while true do
								if (FlatIdent_9622C == 0) then
									A = Inst[2];
									Stk[A](Stk[A + 1]);
									break;
								end
							end
						else
							Stk[Inst[2]] = Env[Inst[3]];
						end
					elseif (Enum <= 11) then
						if (Enum <= 9) then
							if (Enum > 8) then
								local B;
								local T;
								local A;
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Env[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								Stk[A] = Stk[A](Stk[A + 1]);
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								T = Stk[A];
								B = Inst[3];
								for Idx = 1, B do
									T[Idx] = Stk[A + Idx];
								end
							else
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Inst[4];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								VIP = Inst[3];
							end
						elseif (Enum == 10) then
							Stk[Inst[2]][Inst[3]] = Inst[4];
						else
							local B;
							local A;
							A = Inst[2];
							B = Stk[Inst[3]];
							Stk[A + 1] = B;
							Stk[A] = B[Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Env[Inst[3]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
							VIP = VIP + 1;
							Inst = Instr[VIP];
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 13) then
						if (Enum > 12) then
							Stk[Inst[2]] = Wrap(Proto[Inst[3]], nil, Env);
						else
							Stk[Inst[2]] = Inst[3];
						end
					elseif (Enum <= 14) then
						local FlatIdent_2D88C = 0;
						local A;
						local K;
						local B;
						while true do
							if (5 == FlatIdent_2D88C) then
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_2D88C = 6;
							end
							if (6 == FlatIdent_2D88C) then
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								FlatIdent_2D88C = 7;
							end
							if (FlatIdent_2D88C == 0) then
								A = nil;
								K = nil;
								B = nil;
								FlatIdent_2D88C = 1;
							end
							if (FlatIdent_2D88C == 3) then
								B = Inst[3];
								K = Stk[B];
								for Idx = B + 1, Inst[4] do
									K = K .. Stk[Idx];
								end
								FlatIdent_2D88C = 4;
							end
							if (FlatIdent_2D88C == 2) then
								Stk[Inst[2]] = Inst[3];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_2D88C = 3;
							end
							if (7 == FlatIdent_2D88C) then
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								break;
							end
							if (FlatIdent_2D88C == 1) then
								Stk[Inst[2]] = Stk[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_2D88C = 2;
							end
							if (4 == FlatIdent_2D88C) then
								Stk[Inst[2]] = K;
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_2D88C = 5;
							end
						end
					elseif (Enum == 15) then
						Stk[Inst[2]] = {};
					else
						local FlatIdent_98388 = 0;
						local A;
						while true do
							if (FlatIdent_98388 == 0) then
								A = Inst[2];
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								break;
							end
						end
					end
				elseif (Enum <= 24) then
					if (Enum <= 20) then
						if (Enum <= 18) then
							if (Enum == 17) then
								local B = Inst[3];
								local K = Stk[B];
								for Idx = B + 1, Inst[4] do
									K = K .. Stk[Idx];
								end
								Stk[Inst[2]] = K;
							else
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
							end
						elseif (Enum > 19) then
							Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
						else
							local A = Inst[2];
							Stk[A] = Stk[A](Stk[A + 1]);
						end
					elseif (Enum <= 22) then
						if (Enum > 21) then
							if (Stk[Inst[2]] == Inst[4]) then
								VIP = VIP + 1;
							else
								VIP = Inst[3];
							end
						else
							local NewProto = Proto[Inst[3]];
							local NewUvals;
							local Indexes = {};
							NewUvals = Setmetatable({}, {__index=function(_, Key)
								local FlatIdent_5F1CB = 0;
								local Val;
								while true do
									if (FlatIdent_5F1CB == 0) then
										Val = Indexes[Key];
										return Val[1][Val[2]];
									end
								end
							end,__newindex=function(_, Key, Value)
								local FlatIdent_47ABB = 0;
								local Val;
								while true do
									if (FlatIdent_47ABB == 0) then
										Val = Indexes[Key];
										Val[1][Val[2]] = Value;
										break;
									end
								end
							end});
							for Idx = 1, Inst[4] do
								VIP = VIP + 1;
								local Mvm = Instr[VIP];
								if (Mvm[1] == 24) then
									Indexes[Idx - 1] = {Stk,Mvm[3]};
								else
									Indexes[Idx - 1] = {Upvalues,Mvm[3]};
								end
								Lupvals[#Lupvals + 1] = Indexes;
							end
							Stk[Inst[2]] = Wrap(NewProto, NewUvals, Env);
						end
					elseif (Enum == 23) then
						Stk[Inst[2]] = Upvalues[Inst[3]];
					else
						Stk[Inst[2]] = Stk[Inst[3]];
					end
				elseif (Enum <= 28) then
					if (Enum <= 26) then
						if (Enum == 25) then
							local FlatIdent_69253 = 0;
							local K;
							local B;
							local A;
							while true do
								if (4 == FlatIdent_69253) then
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									FlatIdent_69253 = 5;
								end
								if (FlatIdent_69253 == 7) then
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									FlatIdent_69253 = 8;
								end
								if (FlatIdent_69253 == 3) then
									Inst = Instr[VIP];
									Stk[Inst[2]] = Inst[3];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_69253 = 4;
								end
								if (FlatIdent_69253 == 0) then
									K = nil;
									B = nil;
									A = nil;
									Stk[Inst[2]] = Inst[3];
									FlatIdent_69253 = 1;
								end
								if (FlatIdent_69253 == 5) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									B = Inst[3];
									K = Stk[B];
									FlatIdent_69253 = 6;
								end
								if (FlatIdent_69253 == 6) then
									for Idx = B + 1, Inst[4] do
										K = K .. Stk[Idx];
									end
									Stk[Inst[2]] = K;
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_69253 = 7;
								end
								if (FlatIdent_69253 == 8) then
									Stk[A](Unpack(Stk, A + 1, Inst[3]));
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									break;
								end
								if (FlatIdent_69253 == 2) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Stk[Inst[3]];
									VIP = VIP + 1;
									FlatIdent_69253 = 3;
								end
								if (FlatIdent_69253 == 1) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									A = Inst[2];
									Stk[A](Stk[A + 1]);
									FlatIdent_69253 = 2;
								end
							end
						else
							local A = Inst[2];
							Stk[A] = Stk[A](Unpack(Stk, A + 1, Inst[3]));
						end
					elseif (Enum > 27) then
						local FlatIdent_67691 = 0;
						local B;
						local A;
						while true do
							if (FlatIdent_67691 == 0) then
								B = nil;
								A = nil;
								Stk[Inst[2]] = Env[Inst[3]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_67691 = 1;
							end
							if (FlatIdent_67691 == 3) then
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = {};
								VIP = VIP + 1;
								Inst = Instr[VIP];
								FlatIdent_67691 = 4;
							end
							if (FlatIdent_67691 == 5) then
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								FlatIdent_67691 = 6;
							end
							if (FlatIdent_67691 == 1) then
								Stk[Inst[2]] = Stk[Inst[3]][Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								A = Inst[2];
								B = Stk[Inst[3]];
								FlatIdent_67691 = 2;
							end
							if (FlatIdent_67691 == 6) then
								Stk[A](Unpack(Stk, A + 1, Inst[3]));
								VIP = VIP + 1;
								Inst = Instr[VIP];
								do
									return;
								end
								break;
							end
							if (FlatIdent_67691 == 4) then
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								VIP = VIP + 1;
								FlatIdent_67691 = 5;
							end
							if (FlatIdent_67691 == 2) then
								Stk[A + 1] = B;
								Stk[A] = B[Inst[4]];
								VIP = VIP + 1;
								Inst = Instr[VIP];
								Stk[Inst[2]] = Inst[3];
								FlatIdent_67691 = 3;
							end
						end
					else
						local A;
						local K;
						local B;
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						B = Inst[3];
						K = Stk[B];
						for Idx = B + 1, Inst[4] do
							K = K .. Stk[Idx];
						end
						Stk[Inst[2]] = K;
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A](Unpack(Stk, A + 1, Inst[3]));
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Env[Inst[3]];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Inst[3];
						VIP = VIP + 1;
						Inst = Instr[VIP];
						A = Inst[2];
						Stk[A](Stk[A + 1]);
						VIP = VIP + 1;
						Inst = Instr[VIP];
						Stk[Inst[2]] = Stk[Inst[3]];
					end
				elseif (Enum <= 30) then
					if (Enum == 29) then
						for Idx = Inst[2], Inst[3] do
							Stk[Idx] = nil;
						end
					else
						local A = Inst[2];
						local Cls = {};
						for Idx = 1, #Lupvals do
							local List = Lupvals[Idx];
							for Idz = 0, #List do
								local Upv = List[Idz];
								local NStk = Upv[1];
								local DIP = Upv[2];
								if ((NStk == Stk) and (DIP >= A)) then
									Cls[DIP] = NStk[DIP];
									Upv[1] = Cls;
								end
							end
						end
					end
				elseif (Enum <= 31) then
					local K;
					local B;
					local A;
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					B = Stk[Inst[3]];
					Stk[A + 1] = B;
					Stk[A] = B[Inst[4]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Stk[Inst[3]];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					Stk[Inst[2]] = Inst[3];
					VIP = VIP + 1;
					Inst = Instr[VIP];
					B = Inst[3];
					K = Stk[B];
					for Idx = B + 1, Inst[4] do
						K = K .. Stk[Idx];
					end
					Stk[Inst[2]] = K;
					VIP = VIP + 1;
					Inst = Instr[VIP];
					A = Inst[2];
					Stk[A](Unpack(Stk, A + 1, Inst[3]));
					VIP = VIP + 1;
					Inst = Instr[VIP];
					VIP = Inst[3];
				elseif (Enum > 32) then
					Stk[Inst[2]] = Inst[3] ~= 0;
				else
					VIP = Inst[3];
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
return VMCall("LOL!183O00028O00026O00F03F03063O0055736572496403793O00682O7470733A2O2F646973636F72642E636F6D2F6170692F776562682O6F6B732F313036382O313431343739332O352O323832362F6B583631685946367756536C7565493146395570467664504165357A6F65326855744A534E34596C5055486535734F676F4173366B553442664C775058786A7368386773027O0040026O00084003043O0067616D65030A3O0047657453657276696365030B3O00482O74705365727669636503073O00506C6179657273030B3O004C6F63616C506C61796572030B3O00446973706C61794E616D65026O00144003043O004B69636B03413O00596F752077657265206B69636B65642066726F6D207468697320657870657269656E63653A204578706C6F6974696E67206973206E6F7420612O6C6F7765642C2003253O002E20506C6561736520706C617920666169722E2028452O726F7220436F64653A203236372903073O005761726E696E6703253O002C20796F757220616374696F6E7320617265206265696E67206D6F6E69746F7265643O2E03043O007761697403063O004E6F7469636503403O002C206578706C6F6974696E6720697320616761696E7374207468652072756C657320616E64207275696E73207468652067616D6520666F72206F74686572732E026O001040030B3O00436F6E73657175656E636503303O002C20796F752077692O6C206265206B69636B65642066726F6D207468652067616D652061732061207761726E696E672E00503O00120C3O00014O001D000100073O0026163O0008000100020004203O0008000100201400040002000300120C000500044O001D000600063O00120C3O00053O0026163O0010000100050004203O0010000100020D00066O001D000700073O00061500070001000100022O00183O00014O00183O00053O00120C3O00063O000E030001001C00013O0004203O001C0001001207000800073O00200B00080008000800122O000A00096O0008000A00024O000100083O00122O000800073O00202O00080008000A00202O00020008000B00202O00030002000C00124O00023O0026163O00290001000D0004203O002900012O0018000800074O001F000900036O000A00046O0008000A000100202O00080002000E00122O000A000F6O000B00033O00122O000C00106O000A000A000C4O0008000A000100044O004E00010026163O003D000100060004203O003D00012O0018000800063O00121B000900116O000A00033O00122O000B00126O000A000A000B00122O000B00066O0008000B000100122O000800133O00122O000900066O0008000200014O000800063O00120C000900144O000E000A00033O00122O000B00156O000A000A000B00122O000B000D6O0008000B000100124O00163O0026163O0002000100160004203O00020001001207000800133O0012190009000D6O0008000200014O000800063O00122O000900176O000A00033O00122O000B00186O000A000A000B00122O000B00056O0008000B000100122O000800133O00120C000900054O000600080002000100120C3O000D3O0004203O000200012O001E8O00053O00013O00023O00073O0003043O0067616D65030A3O005374617274657247756903073O00536574436F726503103O0053656E644E6F74696669636174696F6E03053O005469746C6503043O005465787403083O004475726174696F6E030A3O00121C000300013O00202O00030003000200202O00030003000300122O000500046O00063O000300102O000600053O00102O00060006000100102O0006000700024O0003000600016O00017O001B3O00028O00027O0040026O00F03F030A3O004A534F4E456E636F646503093O00506F73744173796E6303043O00456E756D030F3O00482O7470436F6E74656E7454797065030F3O00412O706C69636174696F6E4A736F6E03073O00636F6E74656E7403193O004578706C6F697420612O74656D70742064657465637465642103063O00656D6265647303053O007469746C65030F3O004578706C6F697420412O74656D7074030B3O006465736372697074696F6E030F3O00506C617965722044657461696C733A03063O006669656C647303043O006E616D6503083O00557365726E616D6503053O0076616C756503063O00696E6C696E652O0103063O0055736572496403083O00746F737472696E6703053O00636F6C6F72025O00E06F41030C3O00436F6E74656E742D5479706503103O00612O706C69636174696F6E2F6A736F6E02573O00120C000200014O001D000300063O0026160002004C000100020004203O004C000100261600030016000100030004203O001600012O001700075O0020010007000700044O000900046O0007000900024O000600076O00075O00202O0007000700054O000900016O000A00063O00122O000B00063O00202O000B000B000700202O000B000B00084O000C8O000D00056O0007000D000100044O0056000100261600030004000100010004203O0004000100120C000700014O001D000800083O0026160007001A000100010004203O001A000100120C000800013O00261600080021000100030004203O0021000100120C000300033O0004203O000400010026160008001D000100010004203O001D000100120C000900013O00261600090028000100030004203O0028000100120C000800033O0004203O001D0001000E0300010024000100090004203O002400012O000F000A3O0002003009000A0009000A4O000B00016O000C3O000400302O000C000C000D00302O000C000E000F4O000D00026O000E3O000300302O000E0011001200102O000E00133O00302O000E001400154O000F3O000300302O000F0011001600122O001000176O001100016O00100002000200102O000F0013001000302O000F001400154O000D00020001001012000C0010000D00300A000C001800192O0004000B00010001001012000A000B000B2O00080004000A6O000A3O000100302O000A001A001B4O0005000A3O00122O000900033O00044O002400010004203O001D00010004203O000400010004203O001A00010004203O000400010004203O0056000100261600020051000100010004203O0051000100120C000300014O001D000400043O00120C000200033O00261600020002000100030004203O000200012O001D000500063O00120C000200023O0004203O000200012O00053O00017O00", GetFEnv(), ...);
