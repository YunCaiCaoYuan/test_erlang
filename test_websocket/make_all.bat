@echo off

for /R %%s in (*.erl) do (
    echo erlc  -o ebin %%s
    erlc  -o ebin %%s
)

pause