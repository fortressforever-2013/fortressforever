@echo "vertexlitgeneric" > %1.vmt
@echo { >> %1.vmt
@echo 	"$baseTexture" "weapons/%1" >> %1.vmt
@echo 	"$envmap" "env_cubemap" >> %1.vmt
@echo 	"$envmapmask" "weapons/%1_ref" >> %1.vmt
@echo } >> %1.vmt