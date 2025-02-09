%{
  title: "Setting up a site with zine",
  description: "",
  keywords: ["zine", "zig"],
}

---


## First Steps

Were me just copying the Zine creator [Kristoff's](https://kristoff.it/) personal website, and then started tailoring it to my liking. I'm by no means a designer nor a frontend developer, but I'm happy with the result so far. I'll continue to tweak the layout and design, for instance by implementing my favorite color scheme, Catppuccin.

## What I like About Zine

I like the simplicity of Zine, and it's been really simple to understand how both routing and rendering works. It gets out of my way. `SuperMD` and `SuperHTML` are also nice to work with, but I've yet to see both the full potential of them and the limitations. I've previously worked with for instance `Templ` to generate HTML, so I'm excited to see how Zine compares.

## What's Next

There are some things with the site that are far from finished. For instance, the CSS is a mess, as I've used Kristoff's CSS as a base and then just added some of my own. It needs cleaning up.

### Tags

I'm adding tags to this post, but so far there's no way to filter posts by tags. I'll have to implement that.

### RSS ✅

I'm a big fan of RSS, and it's my preferred way of reading blogs. I've used Kristoff's RSS implementation as a base, but there's one limitation that I want to work on - there's no way to render the full content of a post in the feed, since it's a subpage. This is a limitation of Zine itself, so if I want to change this I'll have to dig into the Zine source code and try to implement it.

The limitation can be seen in this excerpt from the RSS template, where I'm trying to render the full content of a post. This errors out with `only the main page can be rendered for now, sorry!`.

```html
<ctx :loop="$page.subpages()">
  <item>
    <!-- 
      Here goes the rest of the RSS info for the post
    -->
    <description :text="$loop.it.content()"></description>
  </item>
</ctx>
```

#### Update

I've implemented a full RSS feed, which is kind of a hack but it ain't stupid if it works. The solution revolves around fetching the content sections of a page, and then generating the HTML for each section. This is how the XML for the RSS feed looks like now:

```html
<ctx :loop="$page.subpages()">
  <item>
    <title :text="$loop.it.title"></title>
    <!-- 
      Here goes the rest of the RSS info for the post
    -->
    <description :loop="$site.page($loop.it.link()).contentSections()">
      <ctx :text="$loop.it.html()"></ctx>
    </description>
  </item>
</ctx>
```

And the corresponding change to the post:

```
#### [Heading]($section.id("heading"))

Text goes here...
```

An added benefit of this is that the headers are clickable, which is included in the table of contents of the post.