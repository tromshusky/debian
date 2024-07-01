#!/bin/sh

base_svl_name=base
disk=/dev/disk/by-uuid/94a02f18-34ac-41e8-9d71-591f262764c6
boot_entries_subv=debian/@boot
svl=subvolum



current=current
prev=prev
next=next
first_gen=first_gen
gen_name () {
  date '+%s:%N' | sed 's|.....|&:|'
}

echo "LINKING FRESH SUBVOLUME TO BOOT..."

echo "prepare working directory..."
mnt_dir=$(mktemp -d) || exit
c_d=$mnt_dir/$current
mount $disk -o subvol=$boot_entries_subv $mnt_dir || exit
2>/dev/null ln -sn $first_gen $c_d
2>/dev/null mkdir $c_d
echo "     ...done"

echo "cleanup possible work in progress (all until activation)..."
2>/dev/null btrfs subvolume delete $c_d/$next/$svl
2>/dev/null rm $c_d/$next/*
2>/dev/null rmdir $(realpath $c_d/$next)
2>/dev/null rm $c_d/$next
echo "     ...done"

if [ -d $c_d/$prev ]; then
  echo "cleanup old generation..."
  btrfs subvolume delete $c_d/$prev/$svl
  rm $c_d/$prev/*
  rmdir $(realpath $c_d/$prev)
  echo "     ...done"
fi

if [ -d $mnt_dir/$base_svl_name ]; then
  echo "create new generation..."
  new_d=$(gen_name)
  ln -snf ../$new_d $c_d/$next
  mkdir $mnt_dir/$new_d
  ln -snf ../$(readlink $mnt_dir/$current) $mnt_dir/$new_d/$prev
  btrfs subvolume snapshot $mnt_dir/$base_svl_name $mnt_dir/$new_d/$svl
  echo "     ...done"

  echo "activate new generation..."
  ln -snf $new_d $mnt_dir/$current
  echo "     ...done"
fi

echo "remove working directory..."
umount $mnt_dir
rmdir $mnt_dir
echo "     ...done"

echo "DONE"
