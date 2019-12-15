defmodule Day12 do

  defmodule Moon do
    defstruct ~w[position velocity]a

    def new(x, y, z) do
      %__MODULE__{
        position: %{x: x, y: y, z: z},
        velocity: %{x: 0, y: 0, z: 0}
      }
    end

    def new([x, y, z]) do
      new(x, y, z)
    end

    def create(line) do
      Regex.scan(~r/-?\d+/, line)
      |> List.flatten()
      |> Enum.map(&String.to_integer/1)
      |> Moon.new()
    end

    def names() do
      ~w[io europa ganymede callisto]a
    end

    def apply_gravity(moon1, moon2) do
      {x1, x2} = velocities(moon1.position.x, moon2.position.x)
      {y1, y2} = velocities(moon1.position.y, moon2.position.y)
      {z1, z2} = velocities(moon1.position.z, moon2.position.z)

      velocity1 =
        moon1.velocity
        |> Map.update!(:x, & &1 + x1)
        |> Map.update!(:y, & &1 + y1)
        |> Map.update!(:z, & &1 + z1)

      velocity2 =
        moon2.velocity
        |> Map.update!(:x, & &1 + x2)
        |> Map.update!(:y, & &1 + y2)
        |> Map.update!(:z, & &1 + z2)

      new_moon1 = Map.put(moon1, :velocity, velocity1)
      new_moon2 = Map.put(moon2, :velocity, velocity2)

      {new_moon1,new_moon2}
    end

    def apply_velocity(moon) do
      new_position =
        moon.position
        |> Map.update!(:x, & &1 + moon.velocity.x)
        |> Map.update!(:y, & &1 + moon.velocity.y)
        |> Map.update!(:z, & &1 + moon.velocity.z)

      Map.put(moon, :position, new_position)
    end

    def velocities(p1, p2) do
      cond do
        p1 > p2 -> {-1, 1}
        p1 < p2 -> {1, -1}
        true -> {0, 0}
      end
    end

    def total_energy(moon) do
      potential_energy(moon) * kinetic_energy(moon)
    end

    def potential_energy(%Moon{position: %{x: x, y: y, z: z}}) do
      abs(x) + abs(y) + abs(z)
    end

    def kinetic_energy(%Moon{velocity: %{x: x, y: y, z: z}}) do
      abs(x) + abs(y) + abs(z)
    end
  end




  def part1 do
    "../data/input.txt"
    |> load()
    |> create_moons()
    |> init()
    |> step()
  end

  def step(acc, num \\ 1)

  def step({map, _name_combinations}, 1001) do
    map
    |> Enum.map(fn {_name, moon} ->
      Moon.total_energy(moon)
    end)
    |> Enum.sum()
  end

  def step({map, name_combinations}, num) do
    new_map =
      Enum.reduce(name_combinations, map, fn [first, second], acc ->
        moon1 = Map.get(acc, first)
        moon2 = Map.get(acc, second)

        {new_moon1, new_moon2} = Moon.apply_gravity(moon1, moon2)

        acc
        |> Map.put(first, new_moon1)
        |> Map.put(second, new_moon2)
      end)
    |> Enum.map(fn {name, moon} ->
      {name, Moon.apply_velocity(moon)}
    end)
    |> Enum.into(%{})


    step({new_map, name_combinations}, num + 1)
  end

  def init(moons) do
    map = moon_map(moons)
    name_combinations = Combination.combine(Moon.names, 2)
    {map, name_combinations}
  end

  def moon_map(moons) do
    Enum.zip(Moon.names, moons) |> Enum.into(%{})
  end

  def create_moons(list) do
    Enum.map(list, &Moon.create/1)
  end

  def load(file_name) do
    file_name
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> Enum.map(&String.trim_trailing/1)
  end
end
