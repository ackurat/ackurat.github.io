%{
  title: "Exploring gleam through advent of code",
  description: "",
  keywords: ["gleam", "advent-of-code"],
}

---


[Gleam](https://gleam.run) is a statically typed functional programming language that gets compiled to either [BEAM](https://en.wikipedia.org/wiki/BEAM_(Erlang_virtual_machine)) or JavaScript. Its syntax is more akin to [Rust](https://rust-lang.org) than other BEAM languages such as [Elixir](https://elixir-lang.org) and [Erlang](https://erlang.org).

```gleam
pub fn split(x: String, on substring: String) -> List(String) {
  case substring {
    "" -> to_graphemes(x)
    _ ->
      x
      |> string_builder.from_string
      |> string_builder.split(on: substring)
      |> list.map(with: string_builder.to_string)
  }
}
```

## Why I Chose Gleam

First and foremost, I wanted to try something new. Gleam ticked quite a few of the boxes of things I like in a language:

- Static type system
- Immutability
- Compiled
- Built-in tooling
- Decent standard library

For the purpose of AoC, it's mainly the type system, tooling and standard library I'm choosing Gleam. I might take on doing something more complicated (and distributed) afterwards.

## First Impressions

As I usually work in procedural languages, getting into the strictly functional paradigm has been the biggest hurdle. Don't get me wrong - I often use the functional style functions of JS, but due to its mutability and dynamic typing, it's far from Gleam. I've previously delved into Elixir, and while it is also functional it's got the dynamic typing to make it less of a jump. After completing the first 8 days of AoC, I'm getting used to it and I see the light that is immutability. In the codebase I spend most time in at work, there's plenty of functionality that modifies in-place, causing both confusion and bugs for developers who are new to the code.

### Missed Functionality #1 - list access by index

When it comes to AoC, it's very common to work with arrays/lists, for instance in a matrix:

```python
matrix = [['a', 'b'], ['c', 'd']]
matrix[0][0] # 'a'
```

Let's say then that a task requires shifting rows by 1:

```python
def shift_row_right(matrix, row_index, n):
    row = matrix[row_index]
    n = n % len(row)
    shifted_row = row[-n:] + row[:-n]
    matrix[row_index] = shifted_row
    return matrix

shift_row_right(matrix, 0, 1) # [['b', 'a'], ['c', 'd']]
```

Performance aside, this is a very simple and neat way of accessing elements in a list. There's no need to iterate over the rows. In Gleam, you can't access lists by index. Instead, you have to iterate through the list until you're on the right index. Pairing this with the immutability means that shifting rows as above is a bit more tedious. For AoC 2016 day 8, this was the solution I came up with for shifting rows with wrap around:

```gleam
pub fn shift_row_right(
  matrix: Matrix(value),
  row: Int,
  shift: Int,
) -> Matrix(value) {
  Matrix(
    cells: list.index_map(matrix.cells, fn(current_row, row_index) {
      case row_index == row {
        True -> {
          current_row
          |> list.split(list.length(current_row) - shift)
          |> fn(split) { list.append(split.1, split.0) }
        }
        False -> current_row
      }
    }),
  )
}
```

We first have to iterate through all the rows, and in case of being on the wrong row we just return it as is. In case of being on the right row, we then need to construct a new row by iterating over the row, first to split it and then over the first part of the new list (`split.1`) in the `list.append` function.