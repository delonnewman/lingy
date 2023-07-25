use Lingy::Test;
use Lingy;

tests <<"...";
- - '*lingy-version*'
  - '{:major 0, :minor 1, :incremental 19, :qualifier nil}'
- - '*clojure-version*'
  - '{:major 1, :minor 11, :incremental 1, :qualifier nil}'

- - (lingy-version)
  - '"$Lingy::VERSION"'
- - (clojure-version)
  - '"1.11.1"'

- - '*HOST*'
  - '"perl"'

- - '*file*'
  - '"NO_SOURCE_PATH"'

- - '*command-line-args*'
  - nil

- - '*command-line-args*'
  - nil

- - '*ns*'
  - '#<Namespace user>'
...
