#include "intLiteral.h"
#include "fltLiteral.h"
#include "boolLiteral.h"

const Literal* IntLiteral::operator+(const Literal& rhs) const  {
  return rhs.opPlus(val);
}
const Literal* IntLiteral::opPlus(float lhs) const  {
  const Literal* node = new FloatLiteral(static_cast<float>(val) + lhs);
  PoolOfNodes::getInstance().add(node);
  return node;
}
const Literal* IntLiteral::opPlus(int lhs) const  {
  const Literal* node = new IntLiteral(lhs + val);
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* IntLiteral::operator-(const Literal& rhs) const  {
  return rhs.opSubt(val);
}
const Literal* IntLiteral::opSubt(float lhs) const  {
  const Literal* node = new FloatLiteral(lhs - val);
  PoolOfNodes::getInstance().add(node);
  return node;
}
const Literal* IntLiteral::opSubt(int lhs) const  {
  const Literal* node = new IntLiteral(lhs - val);
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* IntLiteral::operator*(const Literal& rhs) const  {
  return rhs.opMult(val);
}
const Literal* IntLiteral::opMult(float lhs) const  {
  const Literal* node = new FloatLiteral(lhs * val);
  PoolOfNodes::getInstance().add(node);
  return node;
}
const Literal* IntLiteral::opMult(int lhs) const  {
  const Literal* node = new IntLiteral(lhs * val);
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* IntLiteral::operator/(const Literal& rhs) const  {
  return rhs.opDiv(val);
}
const Literal* IntLiteral::opDiv(float lhs) const  {
  if ( val == 0 ) throw std::string("Zero Division Error");
  const Literal* node = new FloatLiteral(lhs / val);
  PoolOfNodes::getInstance().add(node);
  return node;#include "boolLiteral.h"
}
const Literal* IntLiteral::opDiv(int lhs) const  {
  if ( val == 0 ) throw std::string("Zero Division Error");
  const Literal* node = new IntLiteral(std::floor((float)lhs / val));
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* IntLiteral::operator%(const Literal& rhs) const  {
  return rhs.opMod(val);
}
const Literal* IntLiteral::opMod(float lhs) const  {
  if ( val == 0 ) throw std::string("Zero Division Error");
  const Literal* node;
  float res = std::fmod(lhs, val);
  if( ( val < 0 && res > 0 ) || ( val > 0 && res < 0 ) )
    node = new FloatLiteral( val + res);
  else
    node = new FloatLiteral(res);
  // const Literal* node = new FloatLiteral(std::fmod(lhs, val));
  PoolOfNodes::getInstance().add(node);
  return node;
}
const Literal* IntLiteral::opMod(int lhs) const  {
  if ( val == 0 ) throw std::string("Zero Division Error");
  const Literal* node;
  int res = lhs % val;
  if( ( val < 0 && res > 0 ) || ( val > 0 && res < 0 ) )
    node = new IntLiteral( val + res);
  else
    node = new IntLiteral(res);
  // const Literal* node = new IntLiteral(lhs % val);
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* IntLiteral::operatorIdiv(const Literal& rhs) const  {
  return rhs.opIdiv(val);
}
const Literal* IntLiteral::opIdiv(float lhs) const  {
  if ( val == 0 ) throw std::string("Zero Division Error");
  const Literal* node = new FloatLiteral(std::floor(lhs / val));
  PoolOfNodes::getInstance().add(node);
  return node;
}
const Literal* IntLiteral::opIdiv(int lhs) const  {
  if ( val == 0 ) throw std::string("Zero Division Error");
  const Literal* node = new IntLiteral(std::floor((float)lhs / val));
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* IntLiteral::operatorPow(const Literal& rhs) const  {
  return rhs.opPow(val);
}
const Literal* IntLiteral::opPow(float lhs) const  {
  const Literal* node = new FloatLiteral(std::pow(lhs, val));
  PoolOfNodes::getInstance().add(node);
  return node;
}
const Literal* IntLiteral::opPow(int lhs) const  {
  const Literal* node = new IntLiteral(std::pow(lhs, val));
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* IntLiteral::operator+() const {
  const Literal* node = new IntLiteral(val);
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* IntLiteral::operator-() const {
  const Literal* node = new IntLiteral(-(val));
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* IntLiteral::operator<(const Literal& rhs) const {
  return rhs.opLt(val);
}
const Literal* IntLiteral::opLt(float lhs) const {
  const Literal* node = new BoolLiteral( val < lhs );
  PoolOfNodes::getInstance().add(node);
  return node;
}
const Literal* IntLiteral::opLt(int lhs) const {
  const Literal* node = new BoolLiteral( val < lhs );
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* IntLiteral::operator<=(const Literal& rhs) const {
  return rhs.opLe(val);
}
const Literal* IntLiteral::opLe(float lhs) const {
  const Literal* node = new BoolLiteral( val <= lhs );
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* IntLiteral::opLe(int lhs) const {
  const Literal* node = new BoolLiteral( val <= lhs );
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* IntLiteral::operator==(const Literal& rhs) const {
  return rhs.opEq(val);
}
const Literal* IntLiteral::opEq(float lhs) const {
  const Literal* node = new BoolLiteral( val == lhs );
  PoolOfNodes::getInstance().add(node);
  return node;
}
const Literal* IntLiteral::opEq(int lhs) const {
  const Literal* node = new BoolLiteral( val == lhs );
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* IntLiteral::operator!=(const Literal& rhs) const {
  return rhs.opNe(val);
}
const Literal* IntLiteral::opNe(float lhs) const {
  const Literal* node = new BoolLiteral( val != lhs );
  PoolOfNodes::getInstance().add(node);
  return node;
}
const Literal* IntLiteral::opNe(int lhs) const {
  const Literal* node = new BoolLiteral( val != lhs );!=
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* IntLiteral::operator>=(const Literal& rhs) const {
  return rhs.opGe(val);
}
const Literal* IntLiteral::opGe(float lhs) const {
  const Literal* node = new BoolLiteral( val >= lhs );
  PoolOfNodes::getInstance().add(node);
  return node;
}
const Literal* IntLiteral::opGe(int lhs) const {
  const Literal* node = new BoolLiteral( val >= lhs );
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* IntLiteral::operator>(const Literal& rhs) const {
  return rhs.opGt(val);
}
const Literal* IntLiteral::opGt(float lhs) const {
  const Literal* node = new BoolLiteral( val > lhs );
  PoolOfNodes::getInstance().add(node);
  return node;
}
const Literal* IntLiteral::opGt(int lhs) const {
  const Literal* node = new BoolLiteral( val > lhs );
  PoolOfNodes::getInstance().add(node);
  return node;
}


const Literal* operator<<(const Literal& rhs) const {
  return rhs.opLsh(val);
}
const Literal* opLsh(float lhs) const {
  std::cout << "TypeError: unsupported operand type(s) for <<: 'float' and 'float'" << std::endl;
  return nullptr;
}
const Literal* opLsh(int lhs) const {
  const Literal* node = new IntLiteral(lhs * std::pow(2, val));
  PoolOfNodes::getInstance().add(node);
  return node;
}

const Literal* operator>>(const Literal& rhs) const {
  return rhs.opRsh(val);
}
const Literal* opRsh(float lhs) const {
  std::cout << "TypeError: unsupported operand type(s) for <<: 'float' and 'float'" << std::endl;
  return nullptr;
}
const Literal* opRsh(int lhs) const {
  const Literal* node = new IntLiteral(lhs / std::pow(2, val));
  PoolOfNodes::getInstance().add(node);
  return node;
}
