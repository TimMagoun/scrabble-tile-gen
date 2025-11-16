include <BOSL2/std.scad>
include <BOSL2/joiners.scad>

module test_pair(length, width, snap, thickness, compression, lock = false) {
  depth = 5;
  extra_depth = 0.1; // Change this to 0.4 for closed sockets
  cuboid([max(width + 5, 12), 12, depth], chamfer=.5, edges=[FRONT, "Y"], anchor=BOTTOM)
    attach(BACK)
      rabbit_clip(
        type="pin", length=length, width=width, snap=snap, thickness=thickness, depth=depth,
        compression=compression, lock=lock
      );
  right(width + 13)
    diff("remove")
      cuboid([width + 8, max(12, length + 2), depth + 3], chamfer=.5, edges=[FRONT, "Y"], anchor=BOTTOM)
        tag("remove")
          attach(BACK)
            rabbit_clip(
              type="socket", length=length, width=width, snap=snap, thickness=thickness,
              depth=depth + extra_depth, lock=lock, compression=0
            );
}
// left(37) ydistribute(spacing=28) {
//     test_pair(length=6, width=7, snap=0.25, thickness=0.8, compression=0.1);
//     test_pair(length=3.5, width=7, snap=0.1, thickness=0.8, compression=0.1); // snap = 0.2 gives a firmer connection
//     test_pair(length=3.5, width=5, snap=0.1, thickness=0.8, compression=0.1); // hard to take apart
//   }
// right(17) ydistribute(spacing=28) {
//     test_pair(length=12, width=10, snap=1, thickness=1.2, compression=0.2);
//     test_pair(length=8, width=7, snap=0.75, thickness=0.8, compression=0.2, lock=true); // With lock, very firm and irreversible
//     test_pair(length=8, width=7, snap=0.75, thickness=0.8, compression=0.2, lock=true); // With lock, very firm and irreversible
//   }

// right(17) test_pair(length=12, width=10, snap=1, thickness=1.2, compression=0.2);

width = 10;
length = 8;
depth = 4;
thickness = 1;
snap = 0.25;
extra_depth = 0.2;
compression = 0.1;
lock = false;

// cube([width, depth, 1], anchor=TOP)
//   attach(TOP)
//     rabbit_clip(
//       type="pin", length=length, width=width, snap=snap, thickness=thickness, depth=depth,
//       compression=compression, lock=lock
//     );

rabbit_clip(
  type="socket", length=length, width=width, snap=snap, thickness=thickness,
  depth=depth + extra_depth, lock=lock, compression=0, anchor=BOTTOM
);
