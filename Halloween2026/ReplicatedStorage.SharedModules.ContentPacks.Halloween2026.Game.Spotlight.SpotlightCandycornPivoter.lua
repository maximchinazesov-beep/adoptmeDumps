-- https://lua.expert

local v1 = require("./SpotlightShared")
local t1 = {}
local FireCFrameChanged = Enum.BulkMoveMode.FireCFrameChanged

local function locate(p1, p2) -- line: 62
    local centre = p1.centre
    local v5 = math.floor((math.atan2(p2.Z - centre.Z, p2.X - centre.X) + 3.141592653589793) * p1.sectors_per_radian) % p1.sectors

    return (if p2.Y > p1.split_y then p1.sectors else 0) + v5 + 1
end

local function stop_appearing(p3, p4) -- line: 71
    local appearing, appearing_count = p3.appearing, p3.appearing_count
    local v6 = appearing[p4]
    local v7 = appearing[appearing_count]

    appearing[p4] = v7
    p3.appear_index[v7] = p4
    appearing[appearing_count] = nil
    p3.appear_index[v6] = 0
    p3.appearing_count = appearing_count - 1
end

function t1.new(p5, p6, p7, p8) -- line: 84
    -- upvalues: v1 (copy)
    local CONSTANTS = v1.CONSTANTS
    local candycorn_lod_sectors = CONSTANTS.candycorn_lod_sectors
    local v8 = p5.Y + CONSTANTS.candycorn_lod_layer_split
    local v9 = p7 + CONSTANTS.candycorn_bob_height

    assert(candycorn_lod_sectors >= 2, (("Spotlight needs at least 2 candy corn sectors per layer, not %*"):format(candycorn_lod_sectors)))
    assert(#p6 > 0, "Spotlight has no candy corn spawners to partition around the stage")

    local t2 = {
        v8,
        v8
    }
    local t3 = {
        v8,
        v8
    }
    local t4 = {
        false,
        false
    }
    local n1 = 1e999
    local n2 = 0

    for _, v13 in p6 do
        local Position = v13.Position
        local v15 = math.sqrt((Position.X - p5.X) ^ 2 + (Position.Z - p5.Z) ^ 2)

        n1 = math.min(n1, v15)
        n2 = math.max(n2, v15)

        local v16 = if v8 < Position.Y then 2 else 1

        if t4[v16] then
            t2[v16] = math.min(t2[v16], Position.Y)
        else
            t2[v16] = Position.Y
        end

        if t4[v16] then
            t3[v16] = math.max(t3[v16], Position.Y)
        else
            t3[v16] = Position.Y
        end

        t4[v16] = true
    end

    local v19 = 3.141592653589793 / candycorn_lod_sectors
    local v20 = n1 * math.cos(v19)
    local v21 = (v20 + n2) / 2
    local v22 = (n2 - v20) / 2
    local v23 = n2 * math.sin(v19)
    local v24 = 2 * candycorn_lod_sectors
    local v25 = table.create(v24)
    local v26 = table.create(v24)

    for i = 1, 2 do
        local v27 = (t3[i] - t2[i]) / 2
        local v29 = math.sqrt(v22 * v22 + v23 * v23 + v27 * v27) + v9

        for j = 0, candycorn_lod_sectors - 1 do
            local v30 = (j * 2 + 1) * v19 - 3.141592653589793
            local v31 = (i - 1) * candycorn_lod_sectors + j + 1

            v25[v31] = Vector3.new(p5.X + v21 * math.cos(v30), (t2[i] + t3[i]) / 2, p5.Z + v21 * math.sin(v30))
            v26[v31] = v29
        end
    end

    local v35 = #p6

    return {
        centre = p5,
        sectors = candycorn_lod_sectors,
        sectors_per_radian = candycorn_lod_sectors / 6.283185307179586,
        split_y = v8,
        sector_centres = v25,
        sector_radii = v26,
        heads = table.create(v24, 0),
        owners = table.create(v35),
        handles = table.create(v35),
        rests = table.create(v35),
        bob_cos = table.create(v35),
        bob_sin = table.create(v35),
        spin_cos = table.create(v35),
        spin_sin = table.create(v35),
        cells = table.create(v35),
        nexts = table.create(v35),
        prevs = table.create(v35),
        posed_at = table.create(v35),
        appear_at = table.create(v35),
        appear_index = table.create(v35),
        appearing = table.create(v35),
        appearing_count = 0,
        free = table.create(v35),
        free_count = 0,
        slot_count = 0,
        flight_handles = {},
        flight_trails = {},
        flight_handle_starts = {},
        flight_trail_starts = {},
        flight_velocities = {},
        flight_launched_at = {},
        flight_durations = {},
        flight_index = {},
        flight_count = 0,
        resize = p8,
        margin = v9,
        range = CONSTANTS.candycorn_lod_range,
        interval = 1 / CONSTANTS.candycorn_lod_rate,
        next_tick_at = 0,
        ticked_at = (-1e999),
        parts = table.create(v35),
        cframes = table.create(v35),
        moved = 0
    }
end

function t1.add(p9, p10, p11, p12, p13, p14) -- line: 186
    -- upvalues: v1 (copy)
    assert(p12.UpVector.Y >= 0.9999, (("%* has to rest upright to spin around world Y"):format((p11:GetFullName()))))

    local v38

    if p9.free_count > 0 then
        v38 = p9.free[p9.free_count]
        p9.free_count -= 1
    else
        v38 = p9.slot_count + 1
        p9.slot_count = v38
    end

    local CONSTANTS = v1.CONSTANTS
    local Position = p12.Position
    local v39 = 6.283185307179586 * (Position.X + Position.Z) / CONSTANTS.candycorn_bob_phase_spread
    local v40 = math.cos(v39)
    local v41 = math.sin(v39)
    local XVector = p12.XVector
    local X = XVector.X
    local v42 = -XVector.Z

    p9.owners[v38] = p10
    p9.handles[v38] = p11
    p9.rests[v38] = Position
    p9.bob_cos[v38] = v40
    p9.bob_sin[v38] = v41
    p9.spin_cos[v38] = v40 * X - v41 * v42
    p9.spin_sin[v38] = v41 * X + v40 * v42
    p9.posed_at[v38] = p14

    local centre = p9.centre
    local v46 = math.floor((math.atan2(p13.Z - centre.Z, p13.X - centre.X) + 3.141592653589793) * p9.sectors_per_radian) % p9.sectors
    local v47 = (if p13.Y > p9.split_y then p9.sectors else 0) + v46 + 1
    local v48 = p9.heads[v47]

    p9.cells[v38] = v47
    p9.prevs[v38] = 0
    p9.nexts[v38] = v48

    if v48 ~= 0 then
        p9.prevs[v48] = v38
    end

    p9.heads[v47] = v38

    local v49 = (Position - p9.sector_centres[v47]).Magnitude + p9.margin

    if p9.sector_radii[v47] < v49 then
        p9.sector_radii[v47] = v49
    end

    local v50 = p9.appearing_count + 1

    p9.appearing_count = v50
    p9.appearing[v50] = v38
    p9.appear_index[v38] = v50
    p9.appear_at[v38] = p14

    local v51 = 6.283185307179586 * (p14 / CONSTANTS.candycorn_spin_period % 1)
    local v52 = 6.283185307179586 * (p14 / CONSTANTS.candycorn_bob_period % 1)

    p11.CFrame = CFrame.new(Position + Vector3.new(0, 1, 0) * (CONSTANTS.candycorn_bob_height * math.sin(v52 + v39))) * CFrame.fromOrientation(0, v51 + v39 + math.atan2(v42, X), 0)
    p9.resize(p10, 0)

    return v38
end

function t1.remove(p15, p16) -- line: 246
    local v54 = p15.cells[p16]

    assert(v54 and v54 ~= 0, (("Spotlight's candy corn pivoter has no slot %* to remove"):format(p16)))

    local v57 = p15.prevs[p16]
    local v58 = p15.nexts[p16]

    if v57 == 0 then
        p15.heads[v54] = v58
    else
        p15.nexts[v57] = v58
    end

    if v58 ~= 0 then
        p15.prevs[v58] = v57
    end

    local v59 = p15.appear_index[p16]

    if v59 ~= 0 then
        local appearing, appearing_count = p15.appearing, p15.appearing_count
        local v60 = appearing[v59]
        local v61 = appearing[appearing_count]

        appearing[v59] = v61
        p15.appear_index[v61] = v59
        appearing[appearing_count] = nil
        p15.appear_index[v60] = 0
        p15.appearing_count = appearing_count - 1
    end

    p15.cells[p16] = 0
    p15.owners[p16] = nil
    p15.handles[p16] = nil

    local v62 = p15.free_count + 1

    p15.free_count = v62
    p15.free[v62] = p16
end

function t1.launch(p17, p18, p19, p20, p21, p22) -- line: 275
    local v63 = p17.flight_count + 1

    p17.flight_count = v63
    p17.flight_handles[v63] = p18
    p17.flight_handle_starts[v63] = p18.CFrame
    p17.flight_trails[v63] = p19 or false

    local flight_trail_starts = p17.flight_trail_starts

    if p19 then
        flight_trail_starts[v63] = p19.CFrame
    else
        flight_trail_starts[v63] = CFrame.identity
    end

    p17.flight_velocities[v63] = p20
    p17.flight_launched_at[v63] = p21
    p17.flight_durations[v63] = p22
    p17.flight_index[p18] = v63
end

function t1.land(p23, p24) -- line: 296
    local v64 = p23.flight_index[p24] or error((("%* isn't in flight"):format((p24:GetFullName()))))
    local flight_count = p23.flight_count

    p23.flight_index[p24] = nil

    if v64 ~= flight_count then
        local v65 = p23.flight_handles[flight_count]

        p23.flight_handles[v64] = v65
        p23.flight_handle_starts[v64] = p23.flight_handle_starts[flight_count]
        p23.flight_trails[v64] = p23.flight_trails[flight_count]
        p23.flight_trail_starts[v64] = p23.flight_trail_starts[flight_count]
        p23.flight_velocities[v64] = p23.flight_velocities[flight_count]
        p23.flight_launched_at[v64] = p23.flight_launched_at[flight_count]
        p23.flight_durations[v64] = p23.flight_durations[flight_count]
        p23.flight_index[v65] = v64
    end

    p23.flight_handles[flight_count] = nil
    p23.flight_handle_starts[flight_count] = nil
    p23.flight_trails[flight_count] = nil
    p23.flight_trail_starts[flight_count] = nil
    p23.flight_velocities[flight_count] = nil
    p23.flight_launched_at[flight_count] = nil
    p23.flight_durations[flight_count] = nil
    p23.flight_count = flight_count - 1
end

function t1.step(p25, p26) -- line: 323
    -- upvalues: v1 (copy), FireCFrameChanged (copy)
    if p26 < p25.next_tick_at then
        return
    end

    p25.next_tick_at = math.max(p25.next_tick_at + p25.interval, p26)

    local CONSTANTS = v1.CONSTANTS
    local ticked_at = p25.ticked_at

    p25.ticked_at = p26

    local parts, cframes = p25.parts, p25.cframes
    local candycorn_spin_period, candycorn_bob_period = CONSTANTS.candycorn_spin_period, CONSTANTS.candycorn_bob_period
    local v67 = 6.283185307179586 * (p26 / candycorn_spin_period % 1)
    local v68 = 6.283185307179586 * (p26 / candycorn_bob_period % 1)
    local v69 = math.cos(v67)
    local v70 = math.sin(v67)
    local v71 = math.cos(v68)
    local v72 = math.sin(v68)
    local candycorn_bob_height = CONSTANTS.candycorn_bob_height
    local CurrentCamera = workspace.CurrentCamera
    local _CFrame = CurrentCamera.CFrame
    local CFramePosition, LookVector, RightVector, UpVector = _CFrame.Position, _CFrame.LookVector, _CFrame.RightVector, _CFrame.UpVector
    local X, Y, Z = CFramePosition.X, CFramePosition.Y, CFramePosition.Z
    local X2, Y2, Z2 = LookVector.X, LookVector.Y, LookVector.Z
    local X3, Y3, Z3 = RightVector.X, RightVector.Y, RightVector.Z
    local X4, Y4, Z4 = UpVector.X, UpVector.Y, UpVector.Z
    local ViewportSize = CurrentCamera.ViewportSize
    local v74 = math.tan(math.rad(CurrentCamera.FieldOfView) / 2)
    local v75 = v74 * ViewportSize.X / ViewportSize.Y
    local v77 = math.sqrt(v74 * v74 + 1)
    local v79 = math.sqrt(1 + v75 * v75)
    local range, margin = p25.range, p25.margin
    local v80 = margin * v77
    local v81 = margin * v79
    local v82 = (range + margin) * (range + margin)
    local sector_centres, sector_radii, heads, nexts = p25.sector_centres, p25.sector_radii, p25.heads, p25.nexts
    local handles, rests, bob_cos, bob_sin = p25.handles, p25.rests, p25.bob_cos, p25.bob_sin
    local spin_cos, spin_sin, posed_at, sectors = p25.spin_cos, p25.spin_sin, p25.posed_at, p25.sectors
    local v83 = if CurrentCamera.Focus.Position.Y > p25.split_y then sectors + 1 else 1
    local v84 = v83 + sectors - 1
    local n3 = 0

    for i = v83, v84 do
        local v85 = sector_centres[i]
        local v86 = sector_radii[i]
        local v87 = v85.X - X
        local v88 = v85.Y - Y
        local v89 = v85.Z - Z
        local v90 = v87 * X2 + v88 * Y2 + v89 * Z2
        local v91 = range + v86
        local v92

        if -v86 < v90 and v87 * v87 + v88 * v88 + v89 * v89 <= v91 * v91 then
            if math.abs(v87 * X3 + v88 * Y3 + v89 * Z3) <= v90 * v75 + v86 * v79 then
                if math.abs(v87 * X4 + v88 * Y4 + v89 * Z4) <= v90 * v74 + v86 * v77 then
                    local v95 = heads[i]

                    while true do
                        if v95 == 0 then
                            v92 = n3
                            break
                        end

                        local v96 = rests[v95]
                        local v97 = v96.X - X
                        local v98 = v96.Y - Y
                        local v99 = v96.Z - Z
                        local v100 = v97 * X2 + v98 * Y2 + v99 * Z2
                        local v101, v102, v103, v104, v105

                        if -margin < v100 and v97 * v97 + v98 * v98 + v99 * v99 <= v82 then
                            if math.abs(v97 * X3 + v98 * Y3 + v99 * Z3) <= v100 * v75 + v81 then
                                if math.abs(v97 * X4 + v98 * Y4 + v99 * Z4) <= v100 * v74 + v80 then
                                    v101 = spin_cos[v95]
                                    v102 = spin_sin[v95]
                                    v103 = bob_cos[v95]
                                    v104 = bob_sin[v95]

                                    local v108 = posed_at[v95]

                                    if v108 ~= ticked_at then
                                        local v109 = p26 - v108
                                        local v110 = 6.283185307179586 * (v109 / candycorn_spin_period % 1)
                                        local v111 = math.cos(v110)
                                        local v112 = math.sin(v110)
                                        local v113 = v101 * v111 + v102 * v112

                                        v102 = v102 * v111 - v101 * v112
                                        spin_cos[v95] = v113
                                        spin_sin[v95] = v102

                                        local v114 = 6.283185307179586 * (v109 / candycorn_bob_period % 1)
                                        local v115 = math.cos(v114)
                                        local v116 = math.sin(v114)
                                        local v117 = v103 * v115 + v104 * v116

                                        v104 = v104 * v115 - v103 * v116
                                        v103 = v117
                                        bob_cos[v95] = v117
                                        bob_sin[v95] = v104
                                        v101 = v113
                                    end

                                    posed_at[v95] = p26

                                    local v118 = v69 * v101 - v70 * v102
                                    local v119 = v70 * v101 + v69 * v102
                                    local v120 = candycorn_bob_height * (v72 * v103 + v71 * v104)

                                    v105 = n3 + 1
                                    parts[v105] = handles[v95]
                                    cframes[v105] = CFrame.new(v96.X, v96.Y + v120, v96.Z, v118, 0, v119, 0, 1, 0, -v119, 0, v118)
                                else
                                    v105 = n3
                                end
                            else
                                v105 = n3
                            end
                        else
                            v105 = n3
                        end

                        n3 = v105
                        v95 = nexts[v95]
                    end
                else
                    v92 = n3
                end
            else
                v92 = n3
            end
        else
            v92 = n3
        end

        n3 = v92
    end

    local appearing, appear_at, owners, resize = p25.appearing, p25.appear_at, p25.owners, p25.resize
    local v121 = 1 / CONSTANTS.candycorn_appear_duration

    for i = p25.appearing_count, 1, -1 do
        local v122 = appearing[i]
        local v123 = 1 - (p26 - appear_at[v122]) * v121

        if v123 <= 0 or posed_at[v122] ~= p26 then
            resize(owners[v122], 1)

            local appearing, appearing_count = p25.appearing, p25.appearing_count
            local v124 = appearing[i]
            local v125 = appearing[appearing_count]

            appearing[i] = v125
            p25.appear_index[v125] = i
            appearing[appearing_count] = nil
            p25.appear_index[v124] = 0
            p25.appearing_count = appearing_count - 1
            continue
        end

        resize(owners[v122], 1 - v123 * v123 * v123)
    end

    local v126 = -0.5 * workspace.Gravity
    local flight_trails, flight_trail_starts, flight_handles, flight_handle_starts = p25.flight_trails, p25.flight_trail_starts, p25.flight_handles, p25.flight_handle_starts
    local flight_velocities, flight_launched_at, flight_durations = p25.flight_velocities, p25.flight_launched_at, p25.flight_durations

    for i = 1, p25.flight_count do
        local v129 = math.min(p26 - flight_launched_at[i], flight_durations[i])
        local v130 = flight_velocities[i] * v129 + Vector3.new(0, 1, 0) * (v126 * v129 * v129)

        n3 += 1
        parts[n3] = flight_handles[i]
        cframes[n3] = flight_handle_starts[i] + v130

        local v131 = flight_trails[i]

        if v131 then
            n3 += 1
            parts[n3] = v131
            cframes[n3] = flight_trail_starts[i] + v130
        end
    end

    for i = n3 + 1, p25.moved do
        parts[i] = nil
        cframes[i] = nil
    end

    p25.moved = n3

    if n3 > 0 then
        workspace:BulkMoveTo(parts, cframes, FireCFrameChanged)
    end
end

return table.freeze(t1)
