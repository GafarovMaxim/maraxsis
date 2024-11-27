for _, lab in pairs(data.raw.lab) do
    for _, input in pairs(lab.inputs or {}) do
        if input == "cryogenic-science-pack" then
            lab.inputs = lab.inputs or {}
            table.insert(lab.inputs, "hydraulic-science-pack")
            table.sort(lab.inputs, function(a, b)
                local order_1 = data.raw.tool[a].order or a
                local order_2 = data.raw.tool[b].order or b
                return order_1 < order_2
            end)
            break
        end
    end
end

local function add_hydraulic_pack(tech_name, direct_prereq)
    local tech = data.raw.technology[tech_name]
    if not tech then return end

    if tech.unit and tech.unit.ingredients then table.insert(tech.unit.ingredients, {"hydraulic-science-pack", 1}) end
    if direct_prereq and tech.prerequisites then table.insert(tech.prerequisites, "maraxsis-project-seadragon") end
end

add_hydraulic_pack("legendary-quality", true)
add_hydraulic_pack("promethium-science-pack", false)
table.insert(data.raw["technology"]["promethium-science-pack"].prerequisites, "maraxsis-deepsea-research")
add_hydraulic_pack("research-productivity", false)

for _, machine in pairs(data.raw["assembling-machine"]) do
    if machine.crafting_categories then
        for _, category in pairs(machine.crafting_categories) do
            if category == "crafting" then
                table.insert(machine.crafting_categories, "maraxsis-hydro-plant-or-assembling")
                break
            end
        end
    end
end

for _, silo in pairs(data.raw["rocket-silo"]) do
    if silo.fixed_recipe == "rocket-part" then
        silo.fixed_recipe = nil
        silo.disabled_when_recipe_not_researched = true
    end
end

local simple_coal_liquefaction = data.raw.recipe["coal-liquefaction"]
simple_coal_liquefaction.surface_conditions = simple_coal_liquefaction.surface_conditions or {}
table.insert(simple_coal_liquefaction.surface_conditions, {
    property = "gravity",
    min = 0.5,
})

local empty_heavy_oil_barrel = data.raw.recipe["empty-heavy-oil-barrel"] -- I know it doesn't make sense. But oil processing in space is cool :)
empty_heavy_oil_barrel.surface_conditions = empty_heavy_oil_barrel.surface_conditions or {}
table.insert(empty_heavy_oil_barrel.surface_conditions, {
    property = "gravity",
    min = 0.5,
})

local rocket_part = data.raw.recipe["rocket-part"]
rocket_part.surface_conditions = rocket_part.surface_conditions or {}
table.insert(rocket_part.surface_conditions, {
    property = "pressure",
    max = 50000,
})