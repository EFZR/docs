# Format disk

## Open diskpart

```bash
diskpart
```

## List disks

```bash
list disk
```

## Select disk

```bash
select disk 0
```

## Clean disk

```bash
clean
```

## Create partition primary

```bash
create partition primary
```

## Select partition

```bash
select partition 1
```

## Format partition

```bash
format fs=ntfs quick
```

## Assign drive letter

```bash
assign letter=d
```

## Exit diskpart

```bash
exit
```
