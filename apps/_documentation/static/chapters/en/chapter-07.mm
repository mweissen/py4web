## YATL Template Language

``views``:inxx ``template language``:inxx ``HTML``:inxx

web3py uses Python for its models, controllers, and views, although it uses a slightly modified Python syntax in the views to allow more readable code without imposing any restrictions on proper Python usage.

web3py uses ``[[ ... ]]`` to escape Python code embedded in HTML. The advantage of using curly brackets instead of angle brackets is that it's transparent to all common HTML editors. This allows the developer to use those editors to create web3py views.

If this line is in a model it will be applied everywhere, if in a controller only to views for the controller actions, if inside an action only to the view for that action.

Since the developer is embedding Python code into HTML, the document should be indented according to HTML rules, and not Python rules. Therefore, we allow unindented Python inside the ``[[ ... ]]`` tags. Since Python normally uses indentation to delimit blocks of code, we need a different way to delimit them; this is why the web3py template language makes use of the Python keyword ``pass``.

-------
A code block starts with a line ending with a colon and ends with a line beginning with ``pass``. The keyword ``pass`` is not necessary when the end of the block is obvious from the context.
-------

Here is an example:

``
[[
if i == 0:
response.write('i is 0')
else:
response.write('i is not 0')
pass
]]
``:html

Note that ``pass`` is a Python keyword, not a web3py keyword. Some Python editors, such as Emacs, use the keyword ``pass`` to signify the division of blocks and use it to re-indent code automatically.

The web3py template language does exactly the same. When it finds something like:

``
<html><body>
[[for x in range(10):]][[=x]]hello<br />[[pass]]
</body></html>
``:html

it translates it into a program:
``
response.write("""<html><body>""", escape=False)
for x in range(10):
    response.write(x)
    response.write("""hello<br />""", escape=False)
response.write("""</body></html>""", escape=False)
``:python
``response.write`` writes to the ``response.body``.

When there is an error in a web3py view, the error report shows the generated view code, not the actual view as written by the developer. This helps the developer debug the code by highlighting the actual code that is executed (which is something that can be debugged with an HTML editor or the DOM inspector of the browser).

Also note that:
``
[[=x]]
``:html

generates
``response.write``:inxx ``escape``:inxx
``
response.write(x)
``:python

Variables injected into the HTML in this way are escaped by default.
The escaping is ignored if ``x`` is an ``XML`` object, even if escape is set to ``True``.

Here is an example that introduces the ``H1`` helper:
``
[[=H1(i)]]
``:html

which is translated to:
``
response.write(H1(i))
``:python

upon evaluation, the ``H1`` object and its components are recursively serialized, escaped and written to the response body. The tags generated by ``H1`` and inner HTML are not escaped. This mechanism guarantees that all text --- and only text --- displayed on the web page is always escaped, thus preventing XSS vulnerabilities. At the same time, the code is simple and easy to debug.

The method ``response.write(obj, escape=True)`` takes two arguments, the object to be written and whether it has to be escaped (set to ``True`` by default). If ``obj`` has an ``.xml()`` method, it is called and the result written to the response body (the ``escape`` argument is ignored). Otherwise it uses the object's ``__str__`` method to serialize it and, if the escape argument is ``True``, escapes it. All built-in helper objects (``H1`` in the example) are objects that know how to serialize themselves via the ``.xml()`` method.

This is all done transparently. You never need to (and never should) call the ``response.write`` method explicitly.

### Basic syntax

The web3py template language supports all Python control structures. Here we provide some examples of each of them. They can be nested according to usual programming practice.

#### ``for...in``
``for``:inxx

In templates you can loop over any iterable object:
``
[[items = ['a', 'b', 'c']]]
<ul>
[[for item in items:]]<li>[[=item]]</li>[[pass]]
</ul>
``:html

which produces:
``
<ul>
<li>a</li>
<li>b</li>
<li>c</li>
</ul>
``:html

Here ``items`` is any iterable object such as a Python list, Python tuple, or Rows object, or any object that is implemented as an iterator. The elements displayed are first serialized and escaped.

#### ``while``
``while``:inxx

You can create a loop using the while keyword:
``
[[k = 3]]
<ul>
[[while k > 0:]]<li>[[=k]][[k = k - 1]]</li>[[pass]]
</ul>
``:html

which produces:
``
<ul>
<li>3</li>
<li>2</li>
<li>1</li>
</ul>
``:html

#### ``if...elif...else``
``if``:inxx ``elif``:inxx ``else``:inxx

You can use conditional clauses:
``
[[
import random
k = random.randint(0, 100)
]]
<h2>
[[=k]]
[[if k % 2:]]is odd[[else:]]is even[[pass]]
</h2>
``:html

which produces:
``
<h2>
45 is odd
</h2>
``:html

Since it is obvious that ``else`` closes the first ``if`` block, there is no need for a ``pass`` statement, and using one would be incorrect. However, you must explicitly close the ``else`` block with a ``pass``.

Recall that in Python "else if" is written ``elif`` as in the following example:
``
[[
import random
k = random.randint(0, 100)
]]
<h2>
[[=k]]
[[if k % 4 == 0:]]is divisible by 4
[[elif k % 2 == 0:]]is even
[[else:]]is odd
[[pass]]
</h2>
``:html

It produces:
``
<h2>
64 is divisible by 4
</h2>
``:html

#### ``try...except...else...finally``
``try``:inxx ``except``:inxx ``else``:inxx ``finally``:inxx

It is also possible to use ``try...except`` statements in views with one caveat. Consider the following example:
``
[[try:]]
Hello [[= 1 / 0]]
[[except:]]
division by zero
[[else:]]
no division by zero
[[finally:]]
<br />
[[pass]]
``:html

It will produce the following output:
``
Hello division by zero
<br />
``:html

This example illustrates that all output generated before an exception occurs is rendered (including output that preceded the exception) inside the try block. "Hello" is written because it precedes the exception.

#### ``def...return``
``def``:inxx ``return``:inxx

The web3py template language allows the developer to define and implement functions that can return any Python object or a text/html string. Here we consider two examples:
``
[[def itemize1(link): return LI(A(link, _href="http://" + link))]]
<ul>
[[=itemize1('www.google.com')]]
</ul>
``:html

produces the following output:
``
<ul>
<li><a href="http:/www.google.com">www.google.com</a></li>
</ul>
``:html

The function ``itemize1`` returns a helper object that is inserted at the location where the function is called.

Consider now the following code:
``
[[def itemize2(link):]]
<li><a href="http://[[=link]]">[[=link]]</a></li>
[[return]]
<ul>
[[itemize2('www.google.com')]]
</ul>
``:html

It produces exactly the same output as above. In this case, the function ``itemize2`` represents a piece of HTML that is going to replace the web3py tag where the function is called. Notice that there is no '=' in front of the call to ``itemize2``, since the function does not return the text, but it writes it directly into the response.

There is one caveat: functions defined inside a view must terminate with a ``return`` statement, or the automatic indentation will fail.
